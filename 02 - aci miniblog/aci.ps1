# https://markheath.net/post/four-ways-to-deploy-aspnet-core-website-in-azure
# https://docs.microsoft.com/en-us/cli/azure/container?view=azure-cli-latest
# STEP 0 - login, make sure we have the correct subscription selected
az login
az account show --query name -o tsv
az account set -s "MVP"

# STEP 1 - create a resource group
$location = "westeurope"
$resourceGroup = "miniblogaci"
az group create -l $location -n $resourceGroup

# STEP 2 - Linux container
$dockerRepo = "markheath/miniblogcore:v1-linux" # https://hub.docker.com/r/markheath/miniblogcore/
$containerName = "miniblogcore"
$dnsName = "dockersoton1"
az container create -n $containerName --image $dockerRepo -g $resourceGroup `
                    --ip-address public --ports 80 --dns-name-label $dnsName

# STEP 2 - ALTERNATIVE - Windows container (slower to start)
$dockerRepo = "markheath/miniblogcore:v1"
$containerName="miniblogcorewin"
az container create -n $containerName --image $dockerRepo -g $resourceGroup `
                    --ip-address public --ports 80 --os-type Windows

# STEP 3 - check that its working
#$site = az container show --name $containerName --resource-group $resourceGroup --query "ipAddress.ip" -o tsv
#Start-Process http://$site
Start-Process "http://$dnsName.$location.azurecontainer.io"

# STEP 4 - examine the logs
az container logs -n $containerName -g $resourceGroup

# STEP 5 - clean up
az group delete -n $resourceGroup --yes --no-wait