# This Robot Shop App is a sample three-tier E Commerce App that will help in deploying the Containerised App on a Kubernetes Cluster.
# These Instructions will help to udnerstand K8s app deployment and Ingress Controller through Azure Application Gateway.
# Run these command one by one on the terminal as per the steps.

# Pre-Req: 
# 1. Make sure you have a Kubernetes Cluster Read Ready where you will deploy the App.
# 2. To Interact with AKS Cluster, we will be running from Base VM (Linux)
# 3. We have a helm chart that has the code to containerise the application, we will deploy the containerised app on our AKS Cluster  via helm chart.



# 1. Login to the Kubernetes Cluster
# Navigate to AKS Cluster > Connect > Copy the commands and run them on you Base VM.
#Enter the details of your cluster below
$SubscriptionID = 
$ResourceGroup =
$AKSCluster=

az account set --subscription $SubscriptionID
az aks get-credentials --resource-group $ResourceGroup --name $AKSCluster --overwrite-existing

#To Verify if you are connected to kubernetes Cluster run this command:
kubectl get pods -A
# To Confirm if you are in the right AKS cluster, use the below command
kubectl config current-context


# 2. Deploying Container Microservices App via Helm Chart.
# Clone the Robot-shop repository on your Linux Base VM. We will deploy the containers from Helm Chart in here.
git clone https://github.com/Akashghosh24/RobotShop.git

cd RobotShop

# Navigate to the AKS>Helm folder.
cd AKS
cd helm

# Create robot-shop namespace and install the helm chart in this robot-shop namespace
kubectl create ns robot-shop
helm install robot-shop -n robot-shop .
# The Helm install will deploy all the pods running all the microservices containers on the AKS cluster.
 
# To check status of pods in the namespace. All the pods will be running a microservice in the container.
kubectl get pods -n robot-shop

#4. To integrate Application Gateway with AKS:

# For Public to connect to the AKS cluster we need service. 
# to connect to the cluster.
kubectl get svc -n robot-shop
# The IP address available will not be able to connect to AKS cluster.
# Although the AKS is deployed via a Load Balancer, we need Application Gateway Ingress Controller to forward request to AKS cluster
# Navigate to Azure Portal > AKS Cluster > Networking > Go To Virtual Network integration tab > Application Gateway Ingress Controller > Manage
# Check Ingress Controller. You can either integrate existing App Gateway or create new one. Click Save. This will take 10-15 mins
# Also you should have owner access on the Azure Managed RG for AKS since the App Gateway will require Network Contributor access.

# We now need to deploy an Ingress Controller Resource on AKS that will connect with Azure App Gateway for routing. We already have ingress deployment file
# Navigate to the same helm folder and review content of ingress.yaml
cat ingress.yaml

# Deploy the ingress controller
kubectl apply -f ingress.yaml -n robot-shop
# Check if the ingress is deployeed:
kubectl get ingress -n robot-shop

# Copy the IP address and connect from the portaL, and you would be able to connect to the WebServer.
