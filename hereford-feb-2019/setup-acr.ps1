$sharedResGroup = "SharedResources"
az group create -n $sharedResGroup -l "westeurope"

$acrName = "markheathmvp"
az acr create -g $sharedResGroup -n $acrName --sku Basic --admin-enabled

git clone "https://github.com/dockersamples/example-voting-app.git"
Push-Location "example-voting-app/result/dotnet"
az acr build -r $acrname -f .\Dockerfile --os Windows -t result:win .
Pop-Location

Push-Location "example-voting-app/worker/dotnet"
az acr build -r $acrname -f .\Dockerfile --os Windows -t worker:win .
Pop-Location

Push-Location "example-voting-app/vote/dotnet"
az acr build -r $acrname -f .\Dockerfile --os Windows -t vote:win .
Pop-Location