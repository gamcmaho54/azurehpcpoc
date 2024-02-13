targetScope = 'subscription'

param location string
param vmHpcSize string
param vmLicenseSize string
param trustedSourceIp string
@secure()
param adminUsername string
@secure()
param adminPassword string

resource rgnetwork 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: 'rg-network'
  location: location
}

resource rgcompute 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: 'rg-compute'
  location: location
}

resource rgstorage 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: 'rg-storage'
  location: location
}

module network './modules/network.bicep' = {
  name: 'networkDeploy'
  scope: rgnetwork
  params: {
    location: location
  }
}

module bastion './modules/bastion.bicep' = {
  name: 'bastionDeploy'
  scope: rgnetwork
  params: {
    location: location
    bastionSubnetId: network.outputs.bastionSubnetId
  }
}

module compute './modules/compute.bicep' = {
  name: 'computeDeploy'
  scope: rgcompute
  params: {
    location: location
    computeSubnetId: network.outputs.computeSubnetId
    vmHpcSize: vmHpcSize
    vmLicenseSize: vmLicenseSize
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}

module storage './modules/storage.bicep' = {
  name: 'storageDeploy'
  scope: rgstorage
  params: {
    location: location
    trustedSourceIp: trustedSourceIp
    storageSubnetId: network.outputs.storageSubnetId
    privDnsZoneId: network.outputs.privDnsZoneId
  }
}
