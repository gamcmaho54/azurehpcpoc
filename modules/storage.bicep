targetScope = 'resourceGroup'

param location string
param trustedSourceIp string
param storageSubnetId string
param privDnsZoneId string
param storageAccountName string = 'packages${uniqueString(resourceGroup().id)}'
param privEndpointName string = 'pe-${storageAccountName}'

resource storageaccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    allowedCopyScope: 'AAD'
    publicNetworkAccess: 'Enabled'
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    networkAcls: {
      bypass: 'None'
      defaultAction: 'Deny'
      ipRules: [
        {
          value: trustedSourceIp
          action: 'Allow'
        }
      ]
    }
    supportsHttpsTrafficOnly: true
    accessTier: 'Hot'
  }
}

resource blob 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  name: 'default'
  parent: storageaccount
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: blob
  name: 'packages'
  properties: {
    publicAccess: 'None'
  }
}

resource endpoint 'Microsoft.Network/privateEndpoints@2023-09-01' = {
  name: privEndpointName
  location: location
  properties: {
    subnet: {
      id: storageSubnetId
    }
    privateLinkServiceConnections: [
      {
        name: privEndpointName
        properties: {
          privateLinkServiceId: storageaccount.id
          groupIds: [
            'blob'
          ]
        }
      }
    ]
    customNetworkInterfaceName: 'nic-${privEndpointName}'
  }
}

resource dnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-09-01' = {
  name: 'privateDnsDeploy'
  parent: endpoint
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'blob'
        properties: {
          privateDnsZoneId: privDnsZoneId
        }
      }
    ]
  }
}
