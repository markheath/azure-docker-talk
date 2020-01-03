az login
az account show --query name -o tsv
az account set -s "Microsoft Azure Sponsorship"

# STEP 1 - create a resource group
$location = "westeurope"
$aciResourceGroup = "IgniteLondon2020"
az group create -l $location -n $aciResourceGroup

# STEP 2 - Linux container
$dockerRepo = "markheath/miniblogcore:v1-linux" # https://hub.docker.com/r/markheath/miniblogcore/
$containerName = "miniblogcorewin"
$dnsName = "igniteaci2020"
az container create -n $containerName --image $dockerRepo -g $aciResourceGroup `
                    --ip-address public --ports 80 --dns-name-label $dnsName

# STEP 2 - ALTERNATIVE - Windows container (slower to start)
$dockerRepo = "markheath/miniblogcore:v1"
$containerName="miniblogcorewin"
az container create -n $containerName --image $dockerRepo -g $aciResourceGroup `
                    --ip-address public --ports 80 --os-type Windows

# STEP 3 - check that its working
az container show -g $aciResourceGroup -n $containerName

$domainName = az container show -n $containerName -g $aciResourceGroup --query "ipAddress.fqdn" -o tsv
Start-Process http://$domainName
# Start-Process "http://$dnsName.$location.azurecontainer.io"

# STEP 4 - examine the logs
az container logs -n $containerName -g $aciResourceGroup

# STEP 5 - clean up
az group delete -n $aciResourceGroup --yes --no-wait