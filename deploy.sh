location='australiaeast'
rgName='durable-func-logic-demo-rg'
subscription=$(az account show --query id --output tsv)
blobName='testblob'
userPrincipalId=$(az ad signed-in-user show --query id -o tsv)
blobName='source_video.mp4'

# set to 'true' to deploy function and required storage account behind a private endpoint
# if private endpoints are deployed, you'll only be able to deploy the function from within the virtual network
isPrivate='false' 

# create resource group
az group create --location $location --name $rgName

# build function
publishFolder="/bin/Release/net6.0/publish"
cd ./FunctionApp
dotnet publish -c Release

# zip function publish folder
cd ./$publishFolder
zip -r func.zip ./*
cd ../../../../../
mv ./FunctionApp/$publishFolder/func.zip ./func.zip

# zip workflow
cd ./Workflow
zip -r workflow.zip ./*
cd ..
mv ./Workflow/workflow.zip ./workflow.zip

# deploy resources
az deployment group create \
    --name 'main-deployment' \
    --resource-group $rgName \
    --template-file ./infra/deploy.bicep \
    --parameters location=$location \
    --parameters blobName=$blobName \
    --parameters userPrincipalId=$userPrincipalId \
    --parameters isPrivate=$isPrivate

# get deployment output
outputs=$(az deployment group show \
    --name 'main-deployment' \
    --resource-group $rgName \
    --query 'properties.outputs' \
    --output json)

funcAppName=$(echo $outputs | jq '.funcAppName.value' -r)
logicAppName=$(echo $outputs | jq '.logicAppName.value' -r)

# deploy function & workflow apps
# this step will only work if you specified isPrivate='false' at the beginning of the script
az functionapp deployment source config-zip --name $funcAppName --resource-group $rgName --subscription $subscription --src ./func.zip
az logicapp deployment source config-zip --name $logicAppName --resource-group $rgName  --subscription $subscription --src ./workflow.zip
