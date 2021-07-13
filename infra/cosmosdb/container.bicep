@description('Cosmos DB account name')
param accountName string = 'cosmos-${uniqueString(resourceGroup().id)}'

@description('The name for the Core (SQL) database')
param databaseName string

@description('The name for the Core (SQL) database container')
param containerName string

resource account 'Microsoft.DocumentDB/databaseAccounts@2021-04-15' existing = {
  name: accountName
}

resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-04-15' existing = {
  parent: account
  name: databaseName
}

resource container 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2021-04-15' = {
  parent: database
  name: containerName
  properties: {
    resource: {
      id: containerName
      indexingPolicy: {
        indexingMode: 'consistent'
        automatic: true
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/"_etag"/?'
          }
        ]
      }
      partitionKey: {
        paths: [
          '/userid'
        ]
        kind: 'Hash'
      }
      uniqueKeyPolicy: {
        uniqueKeys: []
      }
      conflictResolutionPolicy: {
        mode: 'LastWriterWins'
        conflictResolutionPath: '/_ts'
      }
    }
  }
}

output container object = container
