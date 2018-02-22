# http://markheath.net/post/deploying-arm-templates-azure-cli
az login
az account show --query name -o tsv
az account set -s "MVP"

# create a resource group
$resourceGroup="armtest"
$location="westeurope"
az group create -l $location -n $resourceGroup

# the template we will deploy
$templateUri="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/docker-wordpress-mysql/azuredeploy.json"

$dnsName = "mypublicip72"

# deploy, specifying all template parameters directly
az group deployment create `
    --name TestDeployment `
    --resource-group $resourceGroup `
    --template-uri $templateUri `
    --parameters 'newStorageAccountName=myvhds96' `
                 'mysqlPassword=My5q1P@s5w0rd!' `
                 'adminUsername=mheath' `
                 'adminPassword=Adm1nP@s5w0rd!' `
                 "dnsNameForPublicIP=$dnsName"

# see what's in the group we just created
az resource list -g $resourceGroup -o table

# find out the domain name we can access this from
#az network public-ip list -g $resourceGroup --query "[0].dnsSettings.fqdn" -o tsv

Start-Process "http://$dnsName.$location.cloudapp.azure.com"

# if it doesn't work, SSH in:
ssh mheath@mypublicip72.westeurope.cloudapp.azure.com
# see if the wordpress container has exited
docker ps --all
# restart the wordpress container (replace e03 with the id of the exited container)
docker start e03


az group delete -n $resourceGroup --yes --no-wait