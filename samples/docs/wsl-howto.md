# How to setup a developer environment on Linux or Windows Subsystem for Linux?

Run powershell (cmd+R > powershell)

Check WSL
```
wsl --version
```
https://learn.microsoft.com/en-us/windows/wsl/install#install-wsl-

Check winget
```
winget --version
```
https://learn.microsoft.com/en-us/windows/package-manager/winget/

Install 7zip
```
winget install --id 7zip.7zip
```

Download and extract the Fedora base container (Powershell)
```pwsh
$DownloadURL = "https://kojipkgs.fedoraproject.org/packages/Fedora-Container-Base/40/20240222.n.0/images/Fedora-Container-Base-40-20240222.n.0.x86_64.tar.xz"
$OutputFile = "$env:USERPROFILE\Downloads\Fedora-Container-Base-40-20240222.n.0.x86_64.tar.xz"
Invoke-WebRequest -Uri $DownloadURL -OutFile $OutputFile

$7ZipExe = "C:\Program Files\7-Zip\7z.exe"
$ExtractedDir = "$env:USERPROFILE\Downloads"
$DestinationDir = "$env:USERPROFILE\Downloads\fedora-40-rootfs.tar"
Start-Process -FilePath $7ZipExe -ArgumentList "x `"$OutputFile`" -o`"$ExtractedDir`"" -Wait
$OutputFile = "$env:USERPROFILE\Downloads\" + (Get-Item $OutputFile).BaseName
Start-Process -FilePath $7ZipExe -ArgumentList "x `"$OutputFile`" -o`"$ExtractedDir`"" -Wait

$Hash = "d755805c54d9489cf9eaeb6f92b2b60f778584d8136e94952527cf7b9be28ba2"
Move-Item "$ExtractedDir\$Hash\layer.tar" $DestinationDir
```

Create a new WSL distribution for Fedora
```pwsh
$WSLName = "fedora-quarkus" 
$WSLDir = "$env:USERPROFILE\wsl\$WSLName"
mkdir -p $WSLDir
$RootFSPath = "$env:USERPROFILE\Downloads\fedora-40-rootfs.tar"
wsl --import $WSLName $WSLDir $RootFSPath

```

Verify that the distribution is created
```pwsh
wsl -l -v
```

Start the Fedora WSL distribution
```pwsh
wsl -d $WSLName
```

## User Setup
In bash, as root

Install System tools
```bash
yum install @development-tools zip unzip gh which  dnf-plugins-core
```


```bash
useradd builder
passwd builder
usermod -aG wheel builder
echo '[user]' > /etc/wsl.conf
echo 'default=builder' >> /etc/wsl.conf
echo '[boot]' >> /etc/wsl.conf
echo 'systemd=true' >> /etc/wsl.conf
echo '' >> /etc/wsl.conf
```

Restart WSL
```pwsh
exit
wsl --terminate $WSLName
wsl -d $WSLName
```

```bash
sudo -s

dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

groupadd docker
usermod -aG docker builder
newgrp docker

systemctl enable docker
systemctl start docker
```

## Tools Setup

Docker verification
```bash
whoami
docker ps
docker run hello-world
```

SdkMan
```bash
curl -s "https://get.sdkman.io" | bash
source "/home/builder/.sdkman/bin/sdkman-init.sh"
sdk install java 22-graalce
sdk install maven
sdk install quarkus
```

GitHub
```
cd 
mkdir workspace
cd workspace
gh auth login
gh repo clone QuarkusAcademy/pizza-delivery
```

Build project
```
cd pizza-delivery
code .
mvn
```

# Ready to roll!

Install an IDE:
* VSCode and WSL Extension
https://code.visualstudio.com/insiders/
https://code.visualstudio.com/docs/remote/wsl

* IntelliJ IDEA
https://www.jetbrains.com/idea/


# After done
If necessary, delete your WSL environment (WARNING: NOT REVERSIBLE)
```pwsh
wsl --unregister $WSLName
```
