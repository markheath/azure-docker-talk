az login
az account show --query name -o tsv
az account set -s "Microsoft Azure Sponsorship"

# 1. Create a resource group
$aksrg = "IgniteLondon2020Aks"
$location = "westeurope" # see valid regions at https://azure.microsoft.com/en-gb/global-infrastructure/services/?products=kubernetes-service
az group create -n $aksrg -l $location 

# Create our AKS Cluster (takes about 8 minutes)
$clusterName = "IgniteAks"
az aks create -g $aksrg -n $clusterName --node-count 3 --generate-ssh-keys

# if there are problems with location of kube config
$env:KUBECONFIG = "$home\.kube\config"

# Get credentials for kubectl to use
kubectl config current-context
az aks get-credentials -g $aksrg -n $clusterName --overwrite-existing

# Check we're connected
kubectl get nodes

kubectl get pods
kubectl get deployments
kubectl logs vote-6c79f79647-8w6wx

# deploy the example vote app
kubectl apply -f .\aks-vote.yml

# watch for the public ip addresses of the vote and result services
kubectl get service --watch

# https://pascalnaber.wordpress.com/2018/06/17/access-dashboard-on-aks-with-rbac-enabled/
kubectl create clusterrolebinding kubernetes-dashboard -n kube-system --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard

# run kubernetes dashboard
az aks browse -g $aksrg -n $clusterName

$voteIp = kubectl get service vote -o jsonpath="{.status.loadBalancer.ingress[0].ip}"
$resultIp = kubectl get service result -o jsonpath="{.status.loadBalancer.ingress[0].ip}"
Start-Process "http://$($voteIp):8082"
Start-Process "http://$($resultIp):8081"

# deploy the example vote app
kubectl apply -f .\aks-vote-v2.yml

Start-Process "http://$($voteIp):8082"

# delete an app deployed with kubectl apply
kubectl delete -f .\aks-vote-v2.yml

# Clean up
az group delete -n $aksrg --yes --no-wait
