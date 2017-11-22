FROM anapsix/alpine-java:8u144b01_server-jre

ENV ZK_HOSTS=localhost:2181 \
    KM_VERSION=1.3.3.14 \
    KM_CONFIGFILE="conf/application.conf" \
    KAFKA_MANAGER_GID=6789 \
    KAFKA_MANAGER_UID=6789

COPY kafka-manager-${KM_VERSION} /kafka-manager-${KM_VERSION}

RUN apk upgrade --update && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* && \
    printf '#!/bin/sh\nexec ./bin/kafka-manager -Dconfig.file=${KM_CONFIGFILE} "${KM_ARGS}" "${@}"\n' > /kafka-manager-${KM_VERSION}/km.sh && \
    chmod +x /kafka-manager-${KM_VERSION}/km.sh && \
    addgroup -g ${KAFKA_MANAGER_GID} kafka-manager && \
    adduser -D -G kafka-manager -s /bin/bash -u ${KAFKA_MANAGER_UID} kafka-manager && \
    chown -R kafka-manager:kafka-manager /kafka-manager-${KM_VERSION}

USER kafka-manager

WORKDIR /kafka-manager-${KM_VERSION}

EXPOSE 9000
ENTRYPOINT ["./km.sh"]