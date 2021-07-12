FROM strimzi/kafka:0.17.0-kafka-2.4.0
USER root:root
RUN mkdir -p /opt/kafka/plugins/camel \
    && cd /tmp \
    && curl --output /tmp/camel-azure-eventhubs-kafka-connector-0.10.1-package.tar.gz https://repo.maven.apache.org/maven2/org/apache/camel/kafkaconnector/camel-azure-eventhubs-kafka-connector/0.10.1/camel-azure-eventhubs-kafka-connector-0.10.1-package.tar.gz \
    && tar -xvzf /tmp/camel-azure-eventhubs-kafka-connector-0.10.1-package.tar.gz --directory /opt/kafka/plugins/camel \
    && rm /tmp/camel-azure-eventhubs-kafka-connector-0.10.1-package.tar.gz
USER 1001
