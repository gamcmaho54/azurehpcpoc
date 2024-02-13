targetScope = 'resourceGroup'

param location string
param privDnsZoneName string = 'privatelink.blob.${environment().suffixes.storage}'

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: 'vnet-hpc-poc'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-compute'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
      {
        name: 'snet-storage'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.0.2.0/24'
        }
      }
    ]
  }
}

resource dnszone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privDnsZoneName
  location: 'global'
}

resource vnetlink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: dnszone
  location: 'global'
  name: 'link-to-${vnet.name}'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}

output computeSubnetId string = vnet.properties.subnets[0].id
output storageSubnetId string = vnet.properties.subnets[1].id
output bastionSubnetId string = vnet.properties.subnets[2].id
output privDnsZoneId string = dnszone.id
