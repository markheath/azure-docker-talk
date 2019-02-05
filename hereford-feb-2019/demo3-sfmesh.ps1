az account show --query name -o tsv

# check if the extension we need is available
az extension list
# to install
az extension add --name mesh
# to upgrade
az extension update --name mesh

# create a resource group
$resGroup = "SmartDevsHerefordSFMesh"
az group create -n $resGroup -l "westeurope"

# retrieve ACR credentials for existing ACR that has our images in
$acrName = "markheathmvp"
$acrUsername = az acr credential show --name $acrName --query username -o tsv
$acrPassword = az acr credential show --name $acrName --query "passwords[0].value" -o tsv

$paramsFile = ".\params.local.json"
$params = @{
    registryServer = @{ value = "$acrName.azurecr.io"}
    registryUserName = @{ value = "$acrUsername"}
    registryPassword = @{ value = "$acrPassword"}
    voteImageName = @{ value = "$acrName.azurecr.io/vote:win"}
    resultImageName = @{ value = "$acrName.azurecr.io/result:win"}
    workerImageName = @{ value = "$acrName.azurecr.io/worker:win"}
}

$params | ConvertTo-Json | Out-File $paramsFile

# deploy the mesh application
$templateFile = ".\sfmesh-voting-app-win.json"
az mesh deployment create -g $resGroup --template-file $templateFile --parameters $paramsFile

# get status of application
$appName = "votingApp"
az mesh app show -g $resGroup -n $appName
az mesh gateway show -n "ingressGateway" -g $resGroup -o table
az mesh network show -g $resGroup -n "votingNetwork"

# see summary of services
az mesh service list -g $resGroup --app-name $appName -o table

# explore the services
az mesh service show -g $resGroup --app-name $appName -n "result-service"
az mesh service show -g $resGroup --app-name $appName -n "vote-service"
az mesh service show -g $resGroup --app-name $appName -n "worker-service"
az mesh service show -g $resGroup --app-name $appName -n "db-service"

# get public ip address
$publicIp = az mesh gateway show -n "ingressGateway" -g $resGroup --query "ipAddress" -o tsv

# let's see if it's working
Start-Process http://$($publicIp):8080/ # voting
Start-Process http://$($publicIp):8081/ # results - not working

# view logs for containers
az mesh code-package-log get -g $resGroup --application-name $appName --service-name "vote-service" --replica-name 0 --code-package-name "voteCode"
az mesh code-package-log get -g $resGroup --application-name $appName --service-name "worker-service" --replica-name 0 --code-package-name "workerCode"
az mesh code-package-log get -g $resGroup --application-name $appName --service-name "result-service" --replica-name 0 --code-package-name "resultCode"
az mesh code-package-log get -g $resGroup --application-name $appName --service-name "db-service" --replica-name 0 --code-package-name "tidbCode"

# scale up vote container to 3 instances (currently seems unreliable)
# https://github.com/Azure/service-fabric-mesh-preview/issues/266
az mesh deployment create -g $resGroup --template-file $templateFile `
 --parameters "{'workerReplicaCount':{'value':'3'}}"

# see services again
az mesh service list -g $resGroup --app-name $appName -o table

# explore the vote service
az mesh service show -g $resGroup --app-name $appName -n "vote-service" -o table

# see the replicas
az mesh service-replica list -g $resGroup --app-name $appName --service-name "vote-service" -o table

# explore a particular replica
az mesh service-replica show -g $resGroup --app-name $appName --service-name "vote-service" -n 0

# delete everything
az group delete -n $resGroup -y