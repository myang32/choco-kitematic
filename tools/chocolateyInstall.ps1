$packageName = 'kitematic'
$url = 'https://github.com/docker/kitematic/releases/download/v0.10.0/Kitematic-0.10.0-Windows.zip'
$url64 = $url
$checksum = '94c217476756269339c610f60926dcf5'
$checksum64 = $checksum
$checksumType = 'md5'
$checksumType64 = $checksumType

$installDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Install-ChocolateyZipPackage "docker-machine" "$url" "$installDir" "$url64" `
 -checksum $checksum -checksumType $checksumType -checksum64 $checksum64 -checksumType64 $checksumType64

$programs = [environment]::GetFolderPath([environment+specialfolder]::Programs)
$shortcutPath = Join-Path "$programs" "Kitematic"
$shortcutFilePath = Join-Path $shortcutPath "Kitematic.lnk"
if(!(Test-Path $shortcutPath)) {
  md $shortcutPath
}

$targetPath = Join-Path $installDir "Kitematic.exe"
 if(Get-Command "Install-ChocolateyShortcut" -ErrorAction SilentlyContinue) { # New, compiled Choco
     Install-ChocolateyShortcut -shortcutFilePath $shortcutFilePath -targetPath $targetPath
 }
 else { # PowerShell Choco
     $shell = New-Object -comObject WScript.Shell
     $shortcut = $shell.CreateShortcut($shortcutFilePath)
     $shortcut.TargetPath = $targetPath
     $shortcut.Save()
 }
