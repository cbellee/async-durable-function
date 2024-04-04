param storageAccountName string
param principalId string
param roleId string = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'

var role = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/${roleId}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: storageAccountName
}

resource storageAccountBlobContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().subscriptionId, 'storageAccountBlobRoleAssignment', storageAccountName, principalId)
  scope: storageAccount
  properties: {
    principalId: principalId
    roleDefinitionId: role
  }
}
