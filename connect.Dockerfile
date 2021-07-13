FROM strimzi/kafka:0.17.0-kafka-2.4.0
USER root:root
RUN mkdir -p /opt/kafka/plugins/camel \
    && cd /tmp \
    && curl --output /tmp/microsoftcorporation-kafka-connect-cosmos-1.1.0.zip https://github.com/microsoft/kafka-connect-cosmosdb/releases/download/v1.1.0/microsoftcorporation-kafka-connect-cosmos-1.1.0.zip \
    && unzip /tmp/microsoftcorporation-kafka-connect-cosmos-1.1.0.zip -d /opt/kafka/plugins \
    && rm /tmp/microsoftcorporation-kafka-connect-cosmos-1.1.0.zip
USER 1001
