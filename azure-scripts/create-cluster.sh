#!/bin/bash

# Variables
# Cloud Lab users should use the existing Resource group name, such as, resourceGroup="cloud-demo-153430"
resourceGroup="acdnd-c4-exercise" \
    clusterName="udacity-cluster" \
    myAcrName="myacr202106"

# Install aks cli
echo "Installing AKS CLI"

az aks install-cli

echo "AKS CLI installed"

# Create AKS cluster
echo "Step 1 - Creating AKS cluster $clusterName"
# Use either one of the "az aks create" commands below
# For users working in their personal Azure account
# This commmand will not work for the Cloud Lab users, because you are not allowed
# to create Log Analytics workspace for monitoring
az aks create \
    --resource-group $resourceGroup \
    --name $clusterName \
    --node-count 1 \
    --enable-addons monitoring \
    --generate-ssh-keys \
    --attach-acr $myAcrName

# For Cloud Lab users
# az aks create \
# --resource-group $resourceGroup \
# --name $clusterName \
# --node-count 1 \
# --generate-ssh-keys

# For Cloud Lab users
# This command will is a substitute for "--enable-addons monitoring" option in the "az aks create"
# Use the log analytics workspace - Resource ID
# For Cloud Lab users, go to the existing Log Analytics workspace --> Properties --> Resource ID. Copy it and use in the command below.
# az aks enable-addons -a monitoring -n $clusterName -g $resourceGroup --workspace-resource-id "/subscriptions/6c39f60b-2bb1-4e37-ad64-faaf30beaca4/resourcegroups/cloud-demo-153430/providers/microsoft.operationalinsights/workspaces/loganalytics-153430"

echo "AKS cluster created: $clusterName"

# Connect to AKS cluster

echo "Step 2 - Getting AKS credentials"

az aks get-credentials \
    --resource-group $resourceGroup \
    --name $clusterName \
    --verbose

echo "Verifying connection to $clusterName"

kubectl get nodes

# Get the ACR login server name
az acr show --name $myAcrName --query loginServer --output table

# echo "Deploying to AKS cluster"
# The command below will deploy a standard application to your AKS cluster.
# kubectl apply -f azure-vote.yaml

# Deploy the application. Run the command below from the parent directory where the *azure-vote-all-in-one-redis.yaml* file is present.
kubectl apply -f azure-vote-all-in-one-redis.yaml
# Test the application
kubectl get service azure-vote-front --watch
# You can also verify that the service is running like this
kubectl get service

# TROUBLESHOOTING

# Check the status of each node
#kubectl get pods

# It may require you to associate the AKS with the ACR
# az aks update -n udacity-cluster -g acdnd-c4-project --attach-acr myacr202106

# Redeploy
# kubectl set image deployment azure-vote-front azure-vote-front=myacr202106.azurecr.io/azure-vote-front:v1

## Generate synthetic load, and autoscale the Pods
# kubectl autoscale deployment azure-vote-front --cpu-percent=50 --min=3 --max=10

# Generate load in the terminal by creating a container with "busybox" image
# Open the bash into the container
# kubectl run -it --rm load-generator --image=busybox /bin/sh

# You will see a new command prompt. Enter the following in the new command prompt.
# It will send an infinite loop of queries to the cluster and increase the load on the cluster.

# while true; do wget -q -O- [Public-IP]; done
# Wait for a few minutes, and go back to the Azure AKS web portal, and check the Application Insights.
# Alternatively, you can run the following in a new terminal window:

# # You can check the increase in the number of pods by using the command below
# kubectl get hpa

# You can get name of HPA
# kubectl get hpa
# # Delete the horizontalpodautoscaler.autoscaling
# kubectl delete hpa azure-vote-front
