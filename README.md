# Azure Durable Function deployment example

## Introduction

This is an example of how to write and deploy an Azure Durable Function. The example function is a simple HTTP triggered function that is called using a Logic app and starts an orchestrator function. The orchestrator function then executes a blob copy activity before returning a response. The solution is deployed using Azure Bicep and the Azure CLI.

## Deployment

To deploy the solution, you will need to have the Azure CLI installed and be logged in to your Azure account.

- Clone the repository
- Navigate to the cloned directory
- Execute the `./deploy.sh` script
- The script will create a resource group, storage accounts, private endpoints, virtual network, app service plans, logic app, function app and private DNS zones.
- The script will also compile the Function App and zip both the function and logic apps before deploying then to the pre-created Azure resources.
- before executing the logic app, you will need to upload a blob named `testblob` to the 'source' container in the storage account prefixed `storblobcopy`.
