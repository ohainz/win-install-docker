#Requires -RunAsAdministrator

$DockerDownloadUrl = "https://download.docker.com/win/static/stable/x86_64/docker-24.0.6.zip"
$DockerComposeDownloadUrl = "https://github.com/docker/compose/releases/download/v2.22.0/docker-compose-windows-x86_64.exe"
$DockerPath = "$Env:Programfiles\Docker"
$DockerServiceFile = "$DockerPath\Dockerd.exe"
$DockerComposeFile = "$DockerPath\docker-compose.exe"
$CurrentLocation = Get-Location;
$DockerServiceName = "docker"

function Test-Administrator  
{  
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  
}

function Add-ToPathVariable($PathToAdd) {
    Write-Host "Try to add docker install path to the path variable ($PathToAdd) ..."
    $NewPathArray = [Environment]::GetEnvironmentVariable("PATH", "Machine") + [IO.Path]::PathSeparator + $PathToAdd
    [Environment]::SetEnvironmentVariable( "Path", $NewPathArray, "Machine" )
}

function Add-FeatureHyperV {
    $hyperv = Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online
    if ($hyperv.State -ne "Enabled") {
        Write-Host "Try to enable Hyper-V ..."
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
    }
}

function Add-FeatureContainers {
    $hyperv = Get-WindowsOptionalFeature -FeatureName Containers -Online
    if ($hyperv.State -ne "Enabled") {
        Write-Host "Try to enable Containers ..."
        Enable-WindowsOptionalFeature -Online -FeatureName Containers -All -NoRestart
    }
}

function Stop-DockerService
{
    if (Test-Path($DockerServiceFile)) {
        Write-Host "Try to stop docker service ..."
        Stop-Service -Name $DockerServiceName
    }
}

function Add-DockerFiles
{
    $registerDockerService = Test-Path($DockerServiceFile)
    $DockerZip = "$CurrentLocation/Docker.zip"

    Write-Host "Try to download docker.zip ..."
    Invoke-WebRequest -Uri $DockerDownloadUrl -OutFile $DockerZip
    Expand-Archive $DockerZip -DestinationPath $Env:ProgramFiles -Force
    if ($registerDockerService) {
        Start-Process $DockerServiceFile -Verb "runAs" -ArgumentList "--register-service"
    }

    Write-Host "Try to download docker-compose.exe ..."
    Invoke-WebRequest -Uri $DockerComposeDownloadUrl -OutFile $DockerComposeFile
    $pathVariableEntries = $env:Path -split ';'

    if (-Not($pathVariableEntries -Contains $DockerPath)) {
        Add-ToPathVariable($DockerPath)
    }

    if (-Not(Test-Path($DockerPath + "\cli-plugins"))) {
        New-Item -Path "$DockerPath" -Name "cli-plugins" -ItemType "directory"
    }
    Copy-Item $DockerComposeFile -Destination $($DockerPath + "\cli-plugins\docker-compose.exe")
}

function Start-DockerService
{
    if (Test-Path($DockerServiceFile)) {
        Write-Host "Try to start docker service ..."
        Start-Service -Name $DockerServiceName
    }
}

# Check admin rights
if (-Not(Test-Administrator)) {
    Write-Host "Please start the script with windows administrator rights"
    $host.Exit()
}

# Enable Feature Hyper-V
Add-FeatureHyperV
# Enable Feature Containers
Add-FeatureContainers
# Stop-Docker-Service
Stop-DockerService
# Add or update Docker-Files
Add-DockerFiles
# Start the Docker-Service
Start-DockerService
