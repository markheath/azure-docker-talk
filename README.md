# Demos for Docker on Azure

Contains demos for running Docker Containers on Azure.

Some of these demos were shown at the [Docker Southampton meetup Feb 2018](https://www.meetup.com/Docker-Southampton/events/246914331).

Makes use of the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest).

## Demo 1 - Docker on VMs

In this demo we use an ARM template to install Docker on a Ubuntu Virtual Machine, and use the Docker VM extension to start a WordPress and mysql container.

- [ARM Template](https://github.com/Azure/azure-quickstart-templates/tree/master/docker-wordpress-mysql)
- [Blog post](https://markheath.net/post/deploy-wordpress-azure-docker-compose-arm)
- [YouTube demo](https://www.youtube.com/watch?v=3otTGLnzeD4)

## Demo 2 - Azure Container Instances (ACI)

In this demo we run a Linux image of the [miniblog.core](https://github.com/madskristensen/Miniblog.Core) ASP.NET Core blogging platform on Azure Container Instances. The included Powershell script also shows how to deploy a Windows version of the same application.

- [Blog post](https://markheath.net/post/four-ways-to-deploy-aspnet-core-website-in-azure)
- [YouTube demo](https://youtu.be/7CnXXpOz1MU)
- [MiniBlog Core Docker Images](https://hub.docker.com/r/markheath/miniblogcore/)

## Demo 3 - Azure Container Instance with a File Share

In this demo we see how to mount an Azure Storage file share as a volume to an ACI container

## Demo 4 - WordPress on Azure Container Instances (ACI)

In this demo we use an ARM template to deploy an Azure Container Instances container group that hosts both the MySQL container and the WordPress container.

## Demo 5 - App Service MiniBlog

In this demo we use App Service to host the MiniBlog app as a Linux container

## Demo 6 - Azure Kubernetes Service (AKS)

In this demo we use the sample AKS application of a voting application with a redis back-end, deploy it to AKS, scale up to three nodes and three replicas and then upgrade to a newer version of the front end container.

- [Demo tutorial](https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough)
- [V2 Docker Hub Image](https://hub.docker.com/r/markheath/azure-vote-front/)

## Demo 7 - WordPress on Azure App Service for Containers

In this demo we use Azure app service to run WordPress as a container, but use the Azure MySQL database service for the backing database. This is preferable to running the database in a container, as it allows us to scale out the number of instances of our web server.