# https://markheath.net/post/build-container-images-with-acr

# for this demo we'll use an ACR that I've already created
$acrName = "pluralsightacr"
$acrSubscription = "MVP"

# move into a folder containing our basic sample application - I've already got it on this PC
# git clone https://github.com/markheath/azure-deploy-manage-containers.git
Push-Location "$env:USERPROFILE/code/pluralsight/azure-deploy-manage-containers/SampleWebApp"

$repositoryName = "samplewebapp"
$tagName = "ignitelondon"

# this command will pack the source code into a tar, upload it, and build the docker image on ACR
az acr build -r $acrName --subscription $acrSubscription `
     -f .\multi-stage.Dockerfile -t "$($repositoryName):$tagName" .

# list all repositories in our ACR
az acr repository list -n $acrName
# show the tags for the samplewebapp repository
az acr repository show-tags -n $acrName --repository $repositoryName
# show details for the samplewebapp:ignitelondon image
az acr repository show -n $acrName -t "$($repositoryName):$tagName"

# n.b. prompts, showing you exactly what will be deleted
az acr repository delete -n $acrName -t "$($repositoryName):$tagName"

Pop-Location