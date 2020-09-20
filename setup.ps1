# Check user is admin
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (!$currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "Script requires admin."
    exit
}

Write-Output "Setting up..."

# Install scoop (does not work yet)
# Set-ExecutionPolicy RemoteSigned -scope CurrentUser
# Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
# cmd /c scoop install git ffmpeg aria2 git-crypt
# cmd /c scoop bucket add nerd-fonts
# cmd /c scoop install FiraCode
