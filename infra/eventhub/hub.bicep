param name string
param messageRetentionInDays int = 1
param partitionCount int = 1
param namespaceName string

resource namespace 'Microsoft.EventHub/namespaces@2021-01-01-preview' existing = {
  name: namespaceName
}

resource hub 'Microsoft.EventHub/namespaces/eventhubs@2021-01-01-preview' = {
  parent: namespace
  name: name
  properties: {
    messageRetentionInDays: messageRetentionInDays
    partitionCount: partitionCount
  }
}
