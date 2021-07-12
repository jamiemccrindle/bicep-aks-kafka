echo '{"message": "ping"}' | kafkacat \
    -b <name>.servicebus.windows.net:9093 \
    -X security.protocol=sasl_ssl \
    -X sasl.mechanism=PLAIN \
    -X sasl.username='$ConnectionString' \
    -X sasl.password='Endpoint=sb://<name>.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=<key>' -t a2b -p 0