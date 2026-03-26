# Stage 1: Build stage
FROM node:20-alpine AS build

USER root
ENV PUPPETEER_SKIP_DOWNLOAD=true

RUN npm install -g flowise

# Stage 2: Runtime stage
FROM node:20-alpine

RUN apk add --no-cache chromium git python3 py3-pip make g++ build-base cairo-dev pango-dev curl su-exec

ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

COPY --from=build /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=build /usr/local/bin /usr/local/bin

COPY docker-entrypoint.sh /usr/local/bin/
RUN sed -i 's/\r$//' /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/docker-entrypoint.sh

RUN mkdir -p /opt/flowise/.flowise/storage \
    && chown -R node:node /opt/flowise

ENV FLOWISE_PATH=/opt/flowise/.flowise
ENV BLOB_STORAGE_PATH=/opt/flowise/.flowise/storage
ENV SECRETKEY_PATH=/opt/flowise/.flowise
ENV DATABASE_PATH=/opt/flowise/.flowise

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["flowise", "start"]
