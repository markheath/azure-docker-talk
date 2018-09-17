# experimental demo - seeing if I can use ACI to run wordpress and mysql
# containers in a single container group and get them talking
# to get it working had to make port 3306 public and use 127.0.0.1 as database address

# https://docs.microsoft.com/en-gb/azure/templates/microsoft.containerinstance/containergroups

az account show --query name -o tsv
az account set -s "MVP"

$resourceGroup = "AciGroupDemo"
$location="westeurope"
az group create -n $resourceGroup -l $location

$containerGroupName = "myWordpress"
$dnsNameLabel = "wordpressaci"

az group deployment create `
    -n TestDeployment -g $resourceGroup `
    --template-file "aci-wordpress.json" `
    --parameters 'mysqlPassword=My5q1P@s5w0rd!' `
    --parameters "containerGroupName=$containerGroupName" `
    --parameters "dnsNameLabel=$dnsNameLabel"

az container list -g $resourceGroup -o table

az container show -g $resourceGroup -n $containerGroupName `
        --query ipAddress.fqdn -o tsv

az container logs -g $resourceGroup -n $containerGroupName

az container delete -g $resourceGroup -n $containerGroupName --yes

az group delete --name $resourceGroup --yes --no-wait