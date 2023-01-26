
param location string = resourceGroup().location
param webAppName string = uniqueString(resourceGroup().id)

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: '${webAppName}-plan'
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: 'F1'
  }
  kind: 'linux'
}

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: 'app-${webAppName}'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'PYTHON|3.10'
    }
  }
}

resource srcControls 'Microsoft.Web/sites/sourcecontrols@2021-01-01' = {
  name: '${appService.name}/web'
  properties: {
    repoUrl: repositoryUrl
    branch: 'main'
    isManualIntegration: true
  }
}
