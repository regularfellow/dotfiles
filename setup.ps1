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

# Windows Terminal
Write-Output "Installing Windows Terminal config..."
$TerminalSettingsDest = "$Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (Test-Path -Path $TerminalSettingsDest) {
    (Get-Item $TerminalSettingsDest).Delete()
}
$null = New-Item -Path $TerminalSettingsDest -ItemType SymbolicLink -Value ".\Microsoft.WindowsTerminal_8wekyb3d8bbwe\settings.json"
$null = New-Item -Path "C:\Users\Public\Pictures\Microsoft.WindowsTerminal_8wekyb3d8bbwe" -ItemType Directory -Force
$null = Copy-Item ".\Microsoft.WindowsTerminal_8wekyb3d8bbwe\ssh.png" -Destination "C:\Users\Public\Pictures\Microsoft.WindowsTerminal_8wekyb3d8bbwe\ssh.png"
