az account show --query name -o tsv

# check if the extension we need is available
az extension list
# to install
az extension add --name mesh
# to upgrade
az extension update --name mesh

# create a resource group
$resGroup = "AzureThamesValleySFMesh"
az group create -n $resGroup -l "westeurope"

# deploy the mesh application
$templateFile = ".\sfmesh-example-voting-app.json"
az mesh deployment create -g $resGroup --template-file $templateFile

# get status of application
$appName = "votingApp"
az mesh app show -g $resGroup -n $appName
az mesh gateway show -n "ingressGateway" -g $resGroup -o table
az mesh network show -g $resGroup -n "votingNetwork"

# get public ip address
$publicIp = az mesh gateway show -n "ingressGateway" -g $resGroup --query "ipAddress" -o tsv

# let's see if it's working
Start-Process http://$($publicIp):8080/ # voting
Start-Process http://$($publicIp):8081/ # results - not working

# view logs for containers
az mesh code-package-log get -g $resGroup --application-name $appName --service-name "voteService" --replica-name 0 --code-package-name "voteCode"
az mesh code-package-log get -g $resGroup --application-name $appName --service-name "resultService" --replica-name 0 --code-package-name "resultCode"
az mesh code-package-log get -g $resGroup --application-name $appName --service-name "workerService" --replica-name 0 --code-package-name "worker"

# see summary of services
az mesh service list -g $resGroup --app-name $appName -o table

# explore the result service
az mesh service show -g $resGroup --app-name $appName -n "resultService"

# scale up vote container to 3 instances (currently seems unreliable)
# https://github.com/Azure/service-fabric-mesh-preview/issues/266
az mesh deployment create -g $resGroup --template-file $templateFile `
 --parameters "{'workerReplicaCount':{'value':'3'}}"

# see services again
az mesh service list -g $resGroup --app-name $appName -o table

# explore the vote service
az mesh service show -g $resGroup --app-name $appName -n "voteService" -o table

# see the replicas
az mesh service-replica list -g $resGroup --app-name $appName --service-name "voteService" -o table

# explore a particular replica
az mesh service-replica show -g $resGroup --app-name $appName --service-name "voteService" -n 0

# delete everything
az group delete -n $resGroup -y