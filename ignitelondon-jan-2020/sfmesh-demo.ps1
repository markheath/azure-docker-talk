az account show --query name -o tsv
az account set -s "Microsoft Azure Sponsorship"

# check if the extension we need is available
az extension list
# to install
az extension add --name mesh
# to upgrade
az extension update --name mesh

# create a resource group
$meshResGroup = "IgniteLondon2020Mesh"
az group create -n $meshResGroup -l "westeurope"

# deploy the mesh application
$templateFile = ".\mesh_rp.windows.json"
az mesh deployment create -g $meshResGroup --template-file $templateFile

# get status of application
$appName = "VotingApp"
az mesh app show -g $meshResGroup -n $appName
az mesh gateway show -n "VotingGateway" -g $meshResGroup -o table
az mesh network show -g $meshResGroup -n "VotingAppNetwork"

# see summary of services
az mesh service list -g $meshResGroup --app-name $appName -o table

# explore the services
az mesh service show -g $meshResGroup --app-name $appName -n "VotingData"
az mesh service show -g $meshResGroup --app-name $appName -n "VotingWeb"

# get public ip address
$publicIp = az mesh gateway show -n "VotingGateway" -g $meshResGroup --query "ipAddress" -o tsv

# let's see if it's working
Start-Process http://$($publicIp) # voting

# view logs for containers
az mesh code-package-log get -g $meshResGroup --application-name $appName --service-name "VotingData" --replica-name 0 --code-package-name "VotingData"
az mesh code-package-log get -g $meshResGroup --application-name $appName --service-name "VotingWeb" --replica-name 0 --code-package-name "VotingWeb"

# delete everything
az group delete -n $meshResGroup -y