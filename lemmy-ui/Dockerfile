FROM node:bullseye as builder

ARG LEMMY_VERSION

WORKDIR /app

RUN apt-get update && \
    apt-get install -y curl yarn python3 gcc wget git

RUN git clone \
    --recurse-submodules \
    https://github.com/LemmyNet/lemmy-ui.git \
    --branch "${LEMMY_VERSION}" \
    --depth 1 /app

COPY .yarnclean .yarnclean

RUN yarn --production --prefer-offline --pure-lockfile
RUN yarn --production --prefer-offline
RUN NODE_OPTIONS="--max-old-space-size=8192" yarn build:prod

RUN yarn autoclean --force
RUN rm -rf ./node_modules/import-sort-parser-typescript
RUN rm -rf ./node_modules/typescript
RUN rm -rf ./node_modules/npm

FROM node:bullseye-slim

ENV NODE_ENV=production

COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/node_modules /app/node_modules

RUN chown -R node:node /app

USER node
EXPOSE 1234
WORKDIR /app

CMD ["node", "dist/js/server.js"]
