Param(
    [Hashtable]$parameters
)

$parameters.multitenant = $false
$parameters.RunSandboxAsOnPrem = $true
$parameters.includeAL = $true
$parameters.doNotExportObjectsToText = $true
$parameters.shortcuts = "none"
$parameters.doNotCheckHealth = $true

$parameters | Out-Host

$parameters.memoryLimit = "12G"

New-BcContainer @parameters


$installedApps = Get-BcContainerAppInfo -containerName $containerName -tenantSpecificProperties -sort DependenciesLast
$installedApps | ForEach-Object {
    Write-Host "Removing $($_.Name)"
    $parameters = @{
        "containerName" = $parameters.ContainerName
        "name" = $_.Name
        "unInstall" = $true
        "force" = $true
    }
    if ($_.Name -ne "Base Application" -and $_.Name -ne "System Application") {
        $parameters.doNotSaveData = $true
        $parameters.doNotSaveSchema = $true
    }
    Unpublish-BcContainerApp @parameters
}

Invoke-ScriptInBcContainer -containerName $parameters.ContainerName -scriptblock { $progressPreference = 'SilentlyContinue' }
