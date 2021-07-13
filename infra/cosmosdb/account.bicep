@description('Cosmos DB account name')
param accountName string = 'cosmos-${uniqueString(resourceGroup().id)}'

@description('Location for the Cosmos DB account.')
param location string = resourceGroup().location

var lowerCaseAccountName = toLower(accountName)

resource account 'Microsoft.DocumentDB/databaseAccounts@2021-04-15' = {
  name: lowerCaseAccountName
  location: location
  properties: {
    databaseAccountOfferType: 'Standard'
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: location
      }
    ]
  }
}


output account object = account
