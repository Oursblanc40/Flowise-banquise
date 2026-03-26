FROM node:20-alpine

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

COPY . .

COPY docker-entrypoint.sh /usr/local/bin/
RUN sed -i 's/\r$//' /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/docker-entrypoint.sh

RUN pnpm install && \
    pnpm build

RUN chown -R node:node .
RUN mkdir -p /opt/flowise/.flowise/storage \
    && chown -R node:node /opt/flowise

ENV FLOWISE_PATH=/opt/flowise/.flowise
ENV BLOB_STORAGE_PATH=/opt/flowise/.flowise/storage
ENV SECRETKEY_PATH=/opt/flowise/.flowise
ENV DATABASE_PATH=/opt/flowise/.flowise

EXPOSE 3000

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["pnpm", "start"]
