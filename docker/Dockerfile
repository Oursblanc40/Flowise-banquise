# Stage 1: Build stage
FROM node:20-alpine AS build

USER root

# Skip downloading Chrome for Puppeteer (saves build time)
ENV PUPPETEER_SKIP_DOWNLOAD=true

# Install latest Flowise globally (specific version can be set: flowise@1.0.0)
RUN npm install -g flowise

# Stage 2: Runtime stage
FROM node:20-alpine

# Install runtime dependencies
RUN apk add --no-cache chromium git python3 py3-pip make g++ build-base cairo-dev pango-dev curl su-exec

# Set the environment variable for Puppeteer to find Chromium
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Copy Flowise from the build stage
COPY --from=build /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=build /usr/local/bin /usr/local/bin

# Copy entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Créer le dossier de stockage et donner les droits à node (pendant qu'on est root)
RUN mkdir -p /opt/flowise/.flowise/storage \
    && chown -R node:node /opt/flowise

# Configurer les chemins de stockage pour que l'application utilise /opt/flowise/.flowise
ENV FLOWISE_PATH=/opt/flowise/.flowise
ENV BLOB_STORAGE_PATH=/opt/flowise/.flowise/storage
ENV SECRETKEY_PATH=/opt/flowise/.flowise
ENV DATABASE_PATH=/opt/flowise/.flowise

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["flowise", "start"]
