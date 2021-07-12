param location string = resourceGroup().location
param name string
param skuName string = 'Basic'
param kafkaEnabled bool = false
param zoneRedundant bool = true

resource kafkaEventhub 'Microsoft.EventHub/namespaces@2021-01-01-preview' = {
  name: name
  location: location
  tags: {}
  sku: {
    name: skuName
  }
  properties: {
    kafkaEnabled: kafkaEnabled
    zoneRedundant: zoneRedundant
  }
}
