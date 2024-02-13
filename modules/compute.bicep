targetScope = 'resourceGroup'

param location string
param computeSubnetId string
param vmHpcSize string
param vmLicenseSize string
@secure()
param adminUsername string
@secure()
param adminPassword string

resource vmhpc 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: 'vm-hpc'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmHpcSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-datacenter-gensecond'
        version: 'latest'
      }
      osDisk: {
        name: 'osdisk-vm-hpc'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
        deleteOption: 'delete'
      }
      dataDisks: [
        {
          name: 'datadisk-0-vm-hpc'
          lun: 0
          diskSizeGB: 1024
          createOption: 'Empty'
          managedDisk: {
            storageAccountType: 'Premium_LRS'
          }
          deleteOption: 'delete'
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nichpc.id
          properties: {
            deleteOption: 'delete'
          }
        }
      ]
    }
    osProfile: {
      computerName: 'vm-hpc'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
  }
}

resource vmlicense 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: 'vm-license'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmLicenseSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-datacenter-gensecond'
        version: 'latest'
      }
      osDisk: {
        name: 'osdisk-vm-license'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
        deleteOption: 'delete'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: niclicense.id
          properties: {
            deleteOption: 'delete'
          }
        }
      ]
    }
    osProfile: {
      computerName: 'vm-license'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
  }
}

resource nichpc 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: 'nic-vm-hpc'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: computeSubnetId
          }
        }
      }
    ]
  }
}

resource niclicense 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: 'nic-vm-license'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: computeSubnetId
          }
        }
      }
    ]
  }
}
