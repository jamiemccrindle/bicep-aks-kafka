# EventHub Kafka Connector

az deployment group create --resource-group rg-eventhub-kafka-connector-001 --template-file infra/main.bicep --parameters @infra/main.parameters.json

helm repo add strimzi https://strimzi.io/charts/

helm install strimzi-kafka strimzi/strimzi-kafka-operator

docker build -t strimzi-custom-connect -f connect.Dockerfile .
docker build -t acrjmcsri7x.azurecr.io/strimzi-custom-connect -f connect.Dockerfile .
docker push acrjmcsri7x.azurecr.io/strimzi-custom-connect

kubectl create secret docker-registry acr \
    --namespace default \
    --docker-server=acrjmcsri7x.azurecr.io \
    --docker-username=acrjmcsri7x \
    --docker-password=<password>

kafkacat \
    -b <name>.servicebus.windows.net:9093 \
    -X security.protocol=sasl_ssl \
    -X sasl.mechanism=PLAIN \
    -X sasl.username='$ConnectionString' \
    -X sasl.password='Endpoint=sb://<name>.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=<key>' \
    -L

kubectl apply -f k8s/connector/eventhub-company-a-secret.yml
kubectl apply -f k8s/connector/eventhub-company-b-secret.yml
kubectl apply -f k8s/connector/mirrormaker2-company-a-company-b.yml

az eventhubs eventhub list --resource-group rg-eventhub-kafka-connector-001 --namespace-name ens-jmc-company-b --query '[].name'

az eventhubs eventhub delete --resource-group rg-eventhub-kafka-connector-001 --namespace-name ens-jmc-company-b --name eventhub-company-a.a2b