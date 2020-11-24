$projectName = Read-Host -Prompt "tkaadf"   # This name is used to generate names for Azure resources, such as storage account name.
$location = Read-Host -Prompt "westcentralus"

$resourceGroupName = "myCentralUSResourceGroup"
$storageAccountName = $projectName + "store"
$containerName = "templates" # The name of the Blob container to be created.

$linkedVMTemplateURL = "https://raw.githubusercontent.com/tka-extern-pge/tka-adf-ir-test/main/nested/VMtemplate.json?" # A completed linked template used in this tutorial.
$vmFileName = "VMtemplate.json" # A file name used for downloading and uploading the linked template.

$linkedIRTemplateURL = "https://raw.githubusercontent.com/tka-extern-pge/tka-adf-ir-test/main/nested/IRtemplate.json?" # A completed linked template used in this tutorial.
$irFileName = "linkedStorageAccount.json" # A file name used for downloading and uploading the linked template.

$linkedIRInstallTemplateURL = "https://raw.githubusercontent.com/tka-extern-pge/tka-adf-ir-test/main/nested/IRInstall.json?" # A completed linked template used in this tutorial.
$irInstallFileName = "linkedStorageAccount.json" # A file name used for downloading and uploading the linked template.


# Download the template
Invoke-WebRequest -Uri $linkedVMTemplateURL -OutFile "$home/$vmFileName"
Invoke-WebRequest -Uri $linkedIRTemplateURL -OutFile "$home/$irFileName"
Invoke-WebRequest -Uri $linkedIRInstallTemplateURL -OutFile "$home/$irInstallFileName"

# Create a resource group
#New-AzResourceGroup -Name $resourceGroupName -Location $location

# Create a storage account
$storageAccount = New-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName -Location $location -SkuName "Standard_LRS"

$context = $storageAccount.Context

# Create a container
New-AzStorageContainer -Name $containerName -Context $context -Permission Container

# Upload the template
Set-AzStorageBlobContent -Container $containerName -File "$home/nested/$vmFileName" -Blob $vmFileName -Context $context

# Upload the template
Set-AzStorageBlobContent -Container $containerName -File "$home/nested/$irFileName" -Blob $irFileName -Context $context

# Upload the template
Set-AzStorageBlobContent -Container $containerName -File "$home/nested/$irInstallFileName" -Blob $irInstallFileName `-Context $context

Write-Host "Press [ENTER] to continue ..."
