@description('Cosmos DB account name')
param accountName string = 'cosmos-${uniqueString(resourceGroup().id)}'

@description('The name for the Core (SQL) database')
param databaseName string

resource account 'Microsoft.DocumentDB/databaseAccounts@2021-04-15' existing = {
  name: accountName
}

resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-04-15' = {
  parent: account
  name: databaseName
  properties: {
    resource: {
      id: databaseName
    }
    options: {
      throughput: 400
    }
  }
}

output database object = database
