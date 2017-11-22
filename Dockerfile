FROM anapsix/alpine-java:8u144b01_server-jre
# inpired by: https://github.com/sheepkiller/kafka-manager-docker/blob/alpine/Dockerfile

ENV ZK_HOSTS=localhost:2181 \
    KM_VERSION=1.3.3.14 \
    KM_REVISION=6cf43e383377a6b37df4faa04d9aff515a265b30 \
    KM_CONFIGFILE="conf/application.conf"

RUN apk add --no-cache git wget && \
    mkdir -p /tmp && \
    cd /tmp && \
    git clone https://github.com/yahoo/kafka-manager && \
    cd /tmp/kafka-manager && \
    git checkout ${KM_REVISION} && \
    echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt && \
    ./sbt clean dist && \
    unzip  -d / ./target/universal/kafka-manager-${KM_VERSION}.zip && \
    rm -fr /tmp/* /root/.sbt /root/.ivy2 && \
    printf '#!/bin/sh\nexec ./bin/kafka-manager -Dconfig.file=${KM_CONFIGFILE} "${KM_ARGS}" "${@}"\n' > /kafka-manager-${KM_VERSION}/km.sh && \
    chmod +x /kafka-manager-${KM_VERSION}/km.sh && \
    rm -fr /kafka-manager-${KM_VERSION}/share \
    apk del git

WORKDIR /kafka-manager-${KM_VERSION}

EXPOSE 9000
ENTRYPOINT ["./km.sh"]