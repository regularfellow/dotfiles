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
if (Test-Path -Path $MpvDest) {
    (Get-Item $MpvDest).Delete()
}
$null = New-Item -Path $MpvDest -ItemType SymbolicLink -Value ".\mpv"

Write-Output "Dotfiles installed."
