# win-install-docker

This repository contains a powershell script to install docker. Please do a reboot after the installation. It allows you to install docker on Window 10 Professional (Windows 10 Home is not supported, because the features **Hyper-V** and **Containers** are required for the installation). There is no uninstall script. You need to remove the components manually if you want to remove docker.

## Test Docker

To test the Docker installation run the command:

```ps
docker run hello-world
```

## Maintain

Check if there is a new version of Docker:

- [Docker releases](https://download.docker.com/win/static/stable/x86_64/)

Check if there is a new version of Docker Compose:

- [Docker Compose releases](https://github.com/docker/compose/releases/)

Replace the URLs in the [PowerShell script](./install-docker.ps1):

```ps
$DockerDownloadUrl = "https://download.docker.com/win/static/stable/x86_64/docker-24.0.6.zip"
$DockerComposeDownloadUrl = "https://github.com/docker/compose/releases/download/v2.22.0/docker-compose-windows-x86_64.exe"
```

## References

Links:

- [Install Docker](https://docs.docker.com/engine/install/binaries/#install-server-and-client-binaries-on-windows)
- [Download Docker Stable](https://download.docker.com/win/static/stable/x86_64/)
- [Check Windows Administrator rights](https://serverfault.com/questions/95431/in-a-powershell-script-how-can-i-check-if-im-running-with-administrator-privil)
- [Enable Hyper-V](https://learn.microsoft.com/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v#enable-hyper-v-using-powershell)
- [Check Hyper-V is enabled](https://stackoverflow.com/questions/37567596/how-do-you-check-to-see-if-hyper-v-is-enabled-using-powershell)
- [Stop Windows Service](https://learn.microsoft.com/powershell/module/microsoft.powershell.management/stop-service?view=powershell-7.3)
- [Install Docker Compose](https://www.ionos.de/digitalguide/server/konfiguration/docker-compose-auf-windows/)
