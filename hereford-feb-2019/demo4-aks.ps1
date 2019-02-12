az login
az account show --query name -o tsv
az account set -s "MVP"

# 1. Create a resource group
$aksrg = "SmartDevsHerefordAks"
$location = "westeurope" # see valid regions at https://azure.microsoft.com/en-gb/global-infrastructure/services/?products=kubernetes-service
az group create -n $aksrg -l $location --self-destruct 1d

# Create our AKS Cluster (takes about 8 minutes)
$clusterName = "MarkAks"
az aks create -g $aksrg -n $clusterName --node-count 3 --generate-ssh-keys

# Get credentials for kubectl to use
az aks get-credentials -g $aksrg -n $clusterName --overwrite-existing

# Check we're connected
kubectl get nodes

# deploy the example vote app
kubectl apply -f .\aks-vote.yml

# watch for the public ip addresses of the vote and result services
kubectl get service --watch

# run kubernetes dashboard
az aks browse -g $aksrg -n $clusterName

# n.b. if the dashboard shows errors, you may need this fix:
# https://pascalnaber.wordpress.com/2018/06/17/access-dashboard-on-aks-with-rbac-enabled/
kubectl create clusterrolebinding kubernetes-dashboard -n kube-system --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard

# deploy the example vote app
kubectl apply -f .\aks-vote-v2.yml

# delete an app deployed with kubectl apply
kubectl delete -f .\aks-vote-v2.yml

# Clean up
az group delete -n $aksrg --yes --no-wait
