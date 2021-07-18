param location string = resourceGroup().location
param companyAEventHubNamespaceName string
// param companyBEventHubNamespaceName string
param companyBCosmosDbAccountName string
param acrName string
param ownerPrincipalId string

module acr 'acr.bicep' = {
  name: 'acr'
  params: {
    acrAdminUserEnabled: true
    acrName: acrName
    acrSku: 'Basic'
    location: location
    ownerPrincipalId: ownerPrincipalId
  }
}

module companyAEventHubNamespace 'eventhub/namespace.bicep' = {
  name: 'companyAEventHubNamespace'
  params: {
    kafkaEnabled: true
    location: location
    name: companyAEventHubNamespaceName
    skuName: 'Standard'
  }
}

module companyAEventHubA2B 'eventhub/hub.bicep' = {
  name: 'companyAEventHubA2B'
  params: {
    name: 'a2b'
    namespaceName: companyAEventHubNamespaceName
  }
}

// module companyBEventHubNamespace 'eventhub/namespace.bicep' = {
//   name: 'companyBEventHubNamespace'
//   params: {
//     kafkaEnabled: true
//     location: location
//     name: companyBEventHubNamespaceName
//     skuName: 'Standard'
//   }
// }

module companyBCosmosDbAccount 'cosmosdb/account.bicep' = {
  name: 'companyBCosmosDbAccount'
  params: {
    accountName: companyBCosmosDbAccountName
  }
}

module companyBCosmosDbDatabase 'cosmosdb/database.bicep' = {
  name: 'companyBCosmosDbDatabase'
  params: {
    accountName: companyBCosmosDbAccountName
    databaseName: 'connect'
  }
}

module companyBCosmosDbA2BContainer 'cosmosdb/container.bicep' = {
  name: 'companyBCosmosDbA2BContainer'
  params: {
    accountName: companyBCosmosDbAccountName
    databaseName: 'connect'
    containerName: 'a2b'
  }
}

module companyBCosmosDbB2AContainer 'cosmosdb/container.bicep' = {
  name: 'companyBCosmosDbB2AContainer'
  params: {
    accountName: companyBCosmosDbAccountName
    databaseName: 'connect'
    containerName: 'b2a'
  }
}
