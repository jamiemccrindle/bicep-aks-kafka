FROM strimzi/kafka:0.17.0-kafka-2.4.0

USER root:root

# RUN yum -y install unzip \
#     && mkdir -p /opt/kafka/plugins/microsoft/microsoftcorporation-kafka-connect-cosmos-1.1.0 \
#     && cd /tmp \
#     && curl --location --output /tmp/microsoftcorporation-kafka-connect-cosmos-1.1.0.zip https://github.com/microsoft/kafka-connect-cosmosdb/releases/download/v1.1.0/microsoftcorporation-kafka-connect-cosmos-1.1.0.zip \
#     && unzip /tmp/microsoftcorporation-kafka-connect-cosmos-1.1.0.zip -d /tmp \
#     && cp -r /tmp/microsoftcorporation-kafka-connect-cosmos-1.1.0/lib/* /opt/kafka/plugins/microsoft/microsoftcorporation-kafka-connect-cosmos-1.1.0 \
#     && rm -r /tmp/microsoftcorporation-kafka-connect-cosmos-1.1.0*

RUN yum -y install unzip 

RUN mkdir -p /opt/kafka/plugins/microsoft/kafka-connect-cosmos \
    && curl --output /opt/kafka/plugins/microsoft/kafka-connect-cosmos/kafka-connect-cosmos-1.1.0-jar-with-dependencies.jar https://github.com/microsoft/kafka-connect-cosmosdb/releases/download/v1.1.0/kafka-connect-cosmos-1.1.0-jar-with-dependencies.jar --location

RUN mkdir -p /opt/kafka/plugins/camel \
    && cd /tmp \
    && curl --output /tmp/camel-azure-eventhubs-kafka-connector-0.10.1-package.tar.gz https://repo.maven.apache.org/maven2/org/apache/camel/kafkaconnector/camel-azure-eventhubs-kafka-connector/0.10.1/camel-azure-eventhubs-kafka-connector-0.10.1-package.tar.gz \
    && tar -xvzf /tmp/camel-azure-eventhubs-kafka-connector-0.10.1-package.tar.gz --directory /opt/kafka/plugins/camel \
    && rm /tmp/camel-azure-eventhubs-kafka-connector-0.10.1-package.tar.gz

USER 1001
