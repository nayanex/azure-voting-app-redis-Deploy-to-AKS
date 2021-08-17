# Create a resource group
myResourceGroup="acdnd-c4-exercise"
clusterName="udacity-cluster"
region="westeurope"
myAcrName="myacr202106"
# Cloud Lab users can ignore this command and should use the existing Resource group,
# such as "cloud-demo-XXXXXX"
az group create --name $myResourceGroup --location $region
# ACR name should not have upper case letter
az acr create --resource-group $myResourceGroup --name $myAcrName --sku Basic
# Log in to the ACR
az acr login --name $myAcrName
# Get the ACR login server name
# To use the azure-vote-front container image with ACR, the image needs to be tagged
# with the login server address of your registry.
# Find the login server address of your registry
az acr show --name $myAcrName --query loginServer --output table
# Associate a tag to the local image
docker tag mcr.microsoft.com/azuredocs/azure-vote-front:v1 myacr202106.azurecr.io/azure-vote-front:v1
# Now you will see myacr202106.azurecr.io/azure-vote-front:v1 if you run docker images
# Push the local registry to remote
docker push myacr202106.azurecr.io/azure-vote-front:v1
# Verify if you image is up in the cloud.
az acr repository list --name myacr202106.azurecr.io --output table
