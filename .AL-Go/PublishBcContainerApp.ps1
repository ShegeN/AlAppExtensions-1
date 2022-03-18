Param(
    [Hashtable]$parameters
)

docker stats --no-stream | out-host

Publish-BcContainerApp @parameters

docker stats --no-stream | out-host

$filename = [System.IO.Path]::GetFileName($parameters.appFile)
$packagesFolder = Join-Path ([System.IO.Path]::GetDirectoryName($parameters.appFile)) "..\.packages"
if (-not (Test-Path $packagesFolder)) {
    $packagesFolder = Join-Path ([System.IO.Path]::GetDirectoryName($parameters.appFile)) ".alPackages"
}
if ($filename -like "Microsoft_System Application_*.*.*.*.app") {
    Write-Host "Publishing Base Application"
    $parameters.appFile = Join-Path $packagesFolder "Microsoft_Base Application.app"
    Publish-BcContainerApp @parameters

    Write-Host "Publishing Application"
    $parameters.appFile = Join-Path $packagesFolder "Microsoft_Application.app"
    Publish-BcContainerApp @parameters
}
elseif ($filename -like "Microsoft_System Application Test Library_*.*.*.*.app") {
    Write-Host "Publishing Tests-TestLibraries"
    $parameters.appFile = Join-Path $packagesFolder "Microsoft_Tests-TestLibraries.app"
    Publish-BcContainerApp @parameters
}

docker stats --no-stream | out-host
