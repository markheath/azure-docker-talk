# in this demo we run a ghost blog on App Service linux container mode

# get logged in to the azure cli
az login
az account show --query name -o tsv
az account set -s "Microsoft Azure Sponsorship"

# create a resource group in our preferred location to use
$appServiceResourceGroup = "IgniteLondon2020AppService"
$location = "westeurope"
az group create -l $location -n $appServiceResourceGroup

# create an app service plan to host
$planName="linuxappservice"
az appservice plan create -n $planName -g $appServiceResourceGroup `
            -l $location --is-linux --sku S1

# create a new webapp based on our DockerHub image
$appName="ghostignite2020"
$dockerRepo = "ghost" # https://hub.docker.com/r/_/ghost/
az webapp create -n $appName -g $appServiceResourceGroup --plan $planName `
                -i $dockerRepo

# configure settings (container environment vairables)
az webapp config appsettings set `
    -n $appName -g $appServiceResourceGroup --settings `
    WEBSITES_PORT=2368

# launch in a browser
$site = az webapp show -n $appName -g $appServiceResourceGroup --query "defaultHostName" -o tsv
Start-Process https://$site

# scale up app service
az appservice plan update -n $planName -g $appServiceResourceGroup --number-of-workers 3

# clean up
az group delete -n $appServiceResourceGroup --yes --no-wait