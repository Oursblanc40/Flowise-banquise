# Build local monorepo image
# docker build --no-cache -t  flowise .

# Run image
# docker run -d -p 3000:3000 flowise

FROM node:20-alpine

# Install system dependencies and build tools
RUN apk update && \
    apk add --no-cache \
        libc6-compat \
        python3 \
        make \
        g++ \
        build-base \
        cairo-dev \
        pango-dev \
        chromium \
        curl \
        su-exec && \
    npm install -g pnpm

ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

ENV NODE_OPTIONS=--max-old-space-size=8192

WORKDIR /usr/src/flowise

# Copy app source
COPY . .

# Copy entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Install dependencies and build
RUN pnpm install && \
    pnpm build

# Give the node user ownership of the application files
RUN chown -R node:node .

# Créer le dossier de stockage et donner les droits à node (pendant qu'on est root)
RUN mkdir -p /opt/flowise/.flowise/storage \
    && chown -R node:node /opt/flowise

# Configurer les chemins de stockage pour que l'application utilise /opt/flowise/.flowise
ENV FLOWISE_PATH=/opt/flowise/.flowise
ENV BLOB_STORAGE_PATH=/opt/flowise/.flowise/storage
ENV SECRETKEY_PATH=/opt/flowise/.flowise
ENV DATABASE_PATH=/opt/flowise/.flowise

EXPOSE 3000

ENTRYPOINT ["docker-entrypoint.sh"]
CMD [ "pnpm", "start" ]
