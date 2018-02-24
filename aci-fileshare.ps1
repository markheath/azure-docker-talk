# demo of using Azure Container instances with a file share

# first let's create our file share
# https://docs.microsoft.com/en-gb/azure/container-instances/container-instances-volume-azure-files
$resourceGroup = "AciShareDemo"
$storageAccountName = "acishare$(Get-Random -Minimum 100 -Maximum 1000)"
$location="westeurope"
$shareName="acishare"

az group create -n $resourceGroup -l $location

az storage account create `
    -g $resourceGroup -n $storageAccountName `
    -l $location --sku Standard_LRS

# Export the connection string as an environment variable. The following 'az storage share create' command
# references this environment variable when creating the Azure file share.
$connectionString = az storage account show-connection-string -g $resourceGroup -n $storageAccountName --output tsv
$env:AZURE_STORAGE_CONNECTION_STRING = $connectionString

# Create the file share
az storage share create -n $shareName

$storageKey = $(az storage account keys list -g $resourceGroup --account-name $storageAccountName --query "[0].value" --output tsv)

$containerName = "hellofiles"
az container create `
    -g $resourceGroup `
    -n $containerName `
    --image microsoft/aci-hellofiles `
    --dns-name-label aci-demo `
    --ports 80 `
    --azure-file-volume-account-name $storageAccountName `
    --azure-file-volume-account-key $storageKey `
    --azure-file-volume-share-name $shareName `
    --azure-file-volume-mount-path /aci/logs/

$domainName = az container show -g $resourceGroup -n $containerName --query ipAddress.fqdn -o tsv
Start-Process "http://$domainName" # http://aci-demo.westeurope.azurecontainer.io/

# STEP 4 - examine the logs
az container logs -n $containerName -g $resourceGroup

az storage share show -n $shareName

az storage file list -s $shareName -o table

$firstFile = az storage file list -s $shareName --query "[0].name" -o tsv

# hmm - can't get this working
$fileUrl = az storage file url -s $shareName -p $firstFile -o tsv
$fileSas = az storage file generate-sas -s $shareName -p $firstFile --expiry "2018-02-24T17:00Z" --permissions "r" -o tsv
Start-Process "$($fileUrl)?$fileSas"

# STEP 5 - clean up
az group delete -n $resourceGroup --yes --no-wait