param location string = resourceGroup().location
param companyAEventHubNamespaceName string
param companyBEventHubNamespaceName string
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
    skuName: 'Premium'
  }
}

module companyAEventHubA2B 'eventhub/hub.bicep' = {
  name: 'companyAEventHubA2B'
  params: {
    name: 'a2b'
    namespaceName: companyAEventHubNamespaceName
  }
}

module companyBEventHubNamespace 'eventhub/namespace.bicep' = {
  name: 'companyBEventHubNamespace'
  params: {
    kafkaEnabled: true
    location: location
    name: companyBEventHubNamespaceName
    skuName: 'Premium'
  }
}
