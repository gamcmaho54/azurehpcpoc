targetScope = 'resourceGroup'

param location string
param bastionSubnetId string

resource pip 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: 'pip-bastion-hpc-poc'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource bastion 'Microsoft.Network/bastionHosts@2023-09-01' = {
  name: 'bastion-hpc-poc'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig-bastion-hpc-poc'
        properties: {
          publicIPAddress: {
            id: pip.id
          }
          subnet: {
            id: bastionSubnetId
          }
        }
      }
    ]
  }
}
