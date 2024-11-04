# Login to Azure (optional in Azure Cloud Shell, as you're already authenticated)
# Connect-AzAccount

# Prompt for variables
$resourceGroupName = Read-Host -Prompt "Enter the Resource Group Name"
$location = Read-Host -Prompt "Enter the Location (e.g., eastus)"
$clusterName = Read-Host -Prompt "Enter the AKS Cluster Name"
$nodeCount = Read-Host -Prompt "Enter the Node Count for the Cluster"
$nodeSize = Read-Host -Prompt "Enter the VM Size for Nodes (e.g., Standard_DS2_v2)"

# Create a resource group
Write-Output "Creating Resource Group..."
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Deploy AKS cluster without a separate agent pool configuration
Write-Output "Creating AKS Cluster..."
New-AzAksCluster `
    -ResourceGroupName $resourceGroupName `
    -Name $clusterName `
    -NodeCount $nodeCount `
    -NodeVmSize $nodeSize `
    -Location $location `
    -DnsNamePrefix $clusterName `
    -EnableRBAC `
    -GenerateSshKey

Write-Output "AKS Cluster Deployment Complete!"

# Optional: Get credentials to manage the AKS cluster
$connect = Read-Host -Prompt "Do you want to connect to the AKS Cluster now? (Y/N)"
if ($connect -eq "Y") {
    Write-Output "Retrieving credentials..."
    Get-AzAksCredential -ResourceGroupName $resourceGroupName -Name $clusterName -OverwriteExisting
    Write-Output "Connected to AKS Cluster. You can now run kubectl commands."
} else {
    Write-Output "Script completed without connecting to the AKS Cluster."
}
