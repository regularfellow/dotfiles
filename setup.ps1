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

$Roaming = [Environment]::GetFolderPath('ApplicationData')
$Local = [Environment]::GetFolderPath('LocalApplicationData')

# Windows Terminal
Write-Output "Installing Windows Terminal config..."
$TerminalSettingsDest = "$Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (Test-Path -Path $TerminalSettingsDest) {
    (Get-Item $TerminalSettingsDest).Delete()
}
$null = New-Item -Path $TerminalSettingsDest -ItemType SymbolicLink -Value ".\Microsoft.WindowsTerminal_8wekyb3d8bbwe\settings.json"
$null = New-Item -Path "C:\Users\Public\Pictures\Microsoft.WindowsTerminal_8wekyb3d8bbwe" -ItemType Directory -Force
$null = Copy-Item ".\Microsoft.WindowsTerminal_8wekyb3d8bbwe\ssh.png" -Destination "C:\Users\Public\Pictures\Microsoft.WindowsTerminal_8wekyb3d8bbwe\ssh.png"

# Sublime
Write-Output "Installing Sublime Text 3 settings..."
$SublimeSettingsDest = "$Roaming\Sublime Text 3\Packages\User\Preferences.sublime-settings"
if (Test-Path -Path $SublimeSettingsDest) {
    (Get-Item $SublimeSettingsDest).Delete()
}
$null = New-Item -Path $SublimeSettingsDest -ItemType SymbolicLink -Value ".\Sublime\Preferences.sublime-settings"

# mpv
Write-Output "Installing mpv config..."
$MpvDest = "$Roaming\mpv"
$MpvDestExists = Test-Path -Path $MpvDest
$MpvDestIsSymlink = $MpvDestExists -and (Get-Item $MpvDest).Attributes.ToString() -match "ReparsePoint"
if ($MpvDestExists -and !($MpvDestIsSymlink)) {
    Remove-Item $MpvDest -Recurse
}
if (!($MpvDestIsSymlink)) {
    $null = New-Item -Path $MpvDest -ItemType SymbolicLink -Value ".\mpv"
}

# check screencap dir exists
if (!(Test-Path -Path "$HOME\Caps")) {
    Write-Error "~/Caps folder is missing."
}

# youtube-dl
Write-Output "Installing youtube-dl config..."
$YtdlDest = "$Roaming\youtube-dl"
$YtdlDestExists = Test-Path -Path $YtdlDest
$YtdlDestIsSymlink = $YtdlDestExists -and (Get-Item $YtdlDest).Attributes.ToString() -match "ReparsePoint"
if ($YtdlDestExists -and !($YtdlDestIsSymlink)) {
    Remove-Item $YtdlDest -Recurse
}
if (!($YtdlDestIsSymlink)) {
    $null = New-Item -Path $YtdlDest -ItemType SymbolicLink -Value ".\youtube-dl"
}

Write-Output "Dotfiles installed."
