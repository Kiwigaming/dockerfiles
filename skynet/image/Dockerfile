# --   Build   --
FROM alpine:latest AS build
ARG public_url=/


WORKDIR /build/

RUN apk update \
    && apk upgrade \
    && apk add -y \
    git \
    nodejs \
    npm \
    cargo \
    make

RUN npm install npm@latest -g

RUN git clone https://github.com/osmarks/skynet.git skynet-master

WORKDIR /build/skynet-master/

RUN cargo build --release
RUN cd webui && npm install --no-audit
RUN cd webui && npx parcel build index.html --public-url $public_url
# -- Build end --

FROM alpine:latest

WORKDIR /root/

RUN apk --no-cache add \
    ca-certificates \
    libstdc++

COPY --from=build /build/skynet-master/target/release .
COPY --from=build /build/skynet-master/skynet.toml .
COPY --from=build /build/skynet-master/webui/dist webui/dist/

EXPOSE 3030
CMD [ "./skynet" ]