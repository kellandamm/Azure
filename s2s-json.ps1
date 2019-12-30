<#
This script automates the deployment of a S2S using an Arm Template in Azure
Script downloads deploy.json file
Asks Questions around mandatory settings for Virtual Network Gateway
#>


Write-Host "Checking to see is AZ module is installed and If not installing"

$checkModule = "AZ"

$Installedmodules = Get-InstalledModule

if ($Installedmodules.name -contains $checkModule)
{

    "$checkModule is installed "

}

else {

    "$checkModule is not installed Installing Az Module" 
     Install-Module -Name Az -AllowClobber -Scope CurrentUser
}

<#
#downloading Raw 
Write-Host "Downloading required Azure Site 2 Site json file"
$client = new-object System.Net.WebClient
$client.DownloadFile("https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-site-to-site-vpn-create/azuredeploy.json","C:\auto\automation\azuredeploy.json")
#>

$rg = Read-Host -Prompt "Please provide Resource Group for Deployment."
$vpnType = Read-Host -Prompt "What is the VPN Type for S2S? Enter RouteBased or PolicyBased"
$localGatewayName = Read-Host -Prompt "What is the name of your on-prem Local Gateway?"
$localGatewayIpAddress = Read-Host -Prompt "What is your on-prem Gateway IP Address?"
$localAddressPrefix = Read-Host -Prompt "What are the local ip address's you want to access your Azure Network? (comma separate)"
$virtualNetworkName = Read-Host -Prompt "What vNet do you want to deploy the Azure S2S VPN to?"
$azureVNetAddressPrefix = Read-Host -Prompt "What VNET do you want to give on-prem access too?"
$subnetName = Read-Host -Prompt "What is the name of the subnet you are giving access to on-prem resources?"
$subnetPrefix = Read-Host -Prompt "what subnet do you want to give S2S access?"
$gatewaySubnetPrefix = Read-Host -Prompt "What Subnet do you want to Assign your VPN Gateway"

#will add logic to create Public IP
#$gatewayPublicIPName = Read-Host -Prompt What
$gatewayName = Read-Host -Prompt "What do you want to name your Azure VPN Gateway?"
$connectionName = Read-Host -Prompt "What name do you want to give for VPN Connection?"
$sharedKey = Read-Host -Prompt "Please provide your shared key for VPN."


#Creating JSON FILE
$jsonMaster = [pscustomobject]@{

    '$schema' = "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#";
    contentVersion = "1.0.0.0";
    parameters = [PSCustomObject]@{
        
        vpnType = [PSCustomObject]@{
        'value' = "$vpnType" 
            }
        localGatewayName = [PSCustomObject]@{
        'value' = "$localGatewayName"
            }
        localGatewayIpAddress = [PSCustomObject]@{
            'value' = "$localGatewayIpAddress"
            }
        virtualNetworkName = [PSCustomObject]@{
            'value' = "$virtualNetworkName"
            }    
        azureVNetAddressPrefix = [PSCustomObject]@{
            'value' = " $azureVNetAddressPrefix"
            }   
        subnetName = [PSCustomObject]@{
            'value' = "$subnetName"
            }    
        subnetPrefix = [PSCustomObject]@{
            'value' = "$subnetPrefix"
            }    
        gatewaySubnetPrefix = [PSCustomObject]@{
            'value' = " $gatewaySubnetPrefix"
            }    
        gatewayPublicIPName = [PSCustomObject]@{
            'value' = "$gatewayPublicIPName"
            }    
        gatewayName = [PSCustomObject]@{
            'value' = "$gatewayName"
            }    
        connectionName  = [PSCustomObject]@{
            'value' = "$connectionName"
            }  
        sharedKey  = [PSCustomObject]@{
            'value' = "$sharedKey"
            }     
    }

}

Write-Host "Exporting data to parameters file "
#line below is variable for json file
$s2sparameter = 'azuredeploy.parameters.json'
$jsonMaster | ConvertTo-Json | Out-File -Path "$s2sparameter"
