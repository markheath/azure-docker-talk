# http://markheath.net/post/four-ways-to-deploy-aspnet-core-website-in-azure
az login
az account show --query name -o tsv
az account set -s "MVP"

$resourceGroup = "miniblogcorelinux"
$location = "westeurope" 
az group create -l $location -n $resourceGroup

$planName="miniblogcorelinux"
az appservice plan create -n $planName -g $resourceGroup -l $location --is-linux --sku B1

# create a new webapp based on our DockerHub image
$appName="miniblogcore3"
$dockerRepo = "markheath/miniblogcore:v1-linux"
az webapp create -n $appName -g $resourceGroup --plan $planName -i $dockerRepo

# launch in a browser
$site = az webapp show -n $appName -g $resourceGroup --query "defaultHostName" -o tsv
Start-Process https://$site

# username password is demo-demo

# clean up
az group delete --name $resourceGroup --yes --no-wait