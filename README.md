# Demos for Docker on Azure

Contains demos for runnning Docker Containers on Azure for the [Docker Southampton meetup Feb 2018](https://www.meetup.com/Docker-Southampton/events/246914331).

Makes use of the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest).

## Demo 1 - Docker on VMs

In this demo we use an ARM template to install Docker on a Ubuntu Virtual Machine, and use the Docker VM extension to start a wordpress and mysql container.

- [ARM Template](https://github.com/Azure/azure-quickstart-templates/tree/master/docker-wordpress-mysql)
- [Blog post](http://markheath.net/post/deploy-wordpress-azure-docker-compose-arm)
- [YouTube demo](https://www.youtube.com/watch?v=3otTGLnzeD4)

## Demo 2 - Azure Container Instances (ACI)

In this demo we run a Linux image of the [miniblog.core](https://github.com/madskristensen/Miniblog.Core) ASP.NET Core blogging platform

- [Blog post](http://markheath.net/post/four-ways-to-deploy-aspnet-core-website-in-azure)
- [YouTube demo](https://youtu.be/7CnXXpOz1MU)
- [MiniBlog Core Docker Images](https://hub.docker.com/r/markheath/miniblogcore/)

## Demo 3 - Azure Kubernetes Service (AKS)

In this demo we use the sample AKS application of a voting application with a redis back-end, deploy it to AKS, scale up to three nodes and three replicas and then upgrade to a newer version of the front end container.

- [Demo tutorial](https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough)
- [V2 Docker Hub Image](https://hub.docker.com/r/markheath/azure-vote-front/)