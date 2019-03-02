FROM openjdk:8u171-jre-alpine

LABEL maintainer "itzg"

RUN apk add --no-cache -U \
    openssl \
    imagemagick \
    lsof \
    su-exec \
    shadow \
    bash \
    curl iputils wget \
    git \
    jq \
    mysql-client \
    tzdata \
    rsync \
    python python-dev py2-pip

RUN pip install mcstatus

HEALTHCHECK CMD mcstatus localhost:$SERVER_PORT ping

RUN addgroup --gid 1000 minecraft \
    && adduser --uid 1000 --system --no-create-home minecraft \
    && mkdir -m 777 /data /mods /config /plugins \
    && chown minecraft:minecraft /data /config /mods /plugins

EXPOSE 25565 25575

ARG RESTIFY_VER=1.1.4
ARG RCON_CLI_VER=1.4.0
ARG MC_SERVER_RUNNER_VER=1.3.0
ARG TOF_BUILDTOOLS_VER=1.2.0
ARG ARCH=amd64

ADD https://github.com/itzg/restify/releases/download/${RESTIFY_VER}/restify_${RESTIFY_VER}_linux_${ARCH}.tar.gz /data/tmp/restify.tgz
RUN tar -x -C /usr/local/bin -f /data/tmp/restify.tgz restify && \
    rm /data/tmp/restify.tgz

ADD https://github.com/itzg/rcon-cli/releases/download/${RCON_CLI_VER}/rcon-cli_${RCON_CLI_VER}_linux_${ARCH}.tar.gz /data/tmp/rcon-cli.tgz
RUN tar -x -C /usr/local/bin -f /data/tmp/rcon-cli.tgz rcon-cli && \
    rm /data/tmp/rcon-cli.tgz

ADD https://github.com/itzg/mc-server-runner/releases/download/${MC_SERVER_RUNNER_VER}/mc-server-runner_${MC_SERVER_RUNNER_VER}_linux_${ARCH}.tar.gz /data/tmp/mc-server-runner.tgz
RUN tar -x -C /usr/local/bin -f /data/tmp/mc-server-runner.tgz mc-server-runner && \
    rm /data/tmp/mc-server-runner.tgz

ADD https://git.faldoria.de/tof/server/build-tools/-/jobs/artifacts/buildtools-${TOF_BUILDTOOLS_VER}/raw/target/ToF-BuildTools.jar?job=release-artifact /data/tmp/tof-buildtools/BuildTools.jar

ONBUILD ARG BUILDTOOLS_OUTPUT=/plugins
ONBUILD COPY Dockerfile *plugins.yml /data/tmp/tof-buildtools/
ONBUILD RUN java -jar /data/tmp/tof-buildtools/BuildTools.jar \
    --config "/data/tmp/tof-buildtools/plugins.yml" \
    --configs "plugins.yml" \
    --dir "/data/tmp/tof-buildtools/" \
    --output ${BUILDTOOLS_OUTPUT} && \
    chown -R minecraft:minecraft ${BUILDTOOLS_OUTPUT} && \
    rm -fR /data/tmp/tof-buildtools/

RUN chmod +x /usr/local/bin/*

VOLUME ["/data","/mods","/config"]
COPY server.properties /data/tmp/server.properties
WORKDIR /data

ENTRYPOINT [ "/start" ]


ENV UID=1000 GID=1000 \
    JVM_XX_OPTS="-XX:+UseG1GC" MEMORY="1G" \
    TYPE=VANILLA VERSION=LATEST FORGEVERSION=RECOMMENDED SPONGEBRANCH=STABLE SPONGEVERSION= LEVEL=world \
    PVP=true DIFFICULTY=easy ENABLE_RCON=true RCON_PORT=25575 RCON_PASSWORD=minecraft \
    LEVEL_TYPE=DEFAULT GENERATOR_SETTINGS= WORLD= MODPACK= MODS= SERVER_PORT=25565 ONLINE_MODE=TRUE CONSOLE=true SERVER_NAME="Dedicated Server"

COPY start.sh /
RUN chmod +x /start.sh

USER minecraft
CMD [ "start.sh" ]
