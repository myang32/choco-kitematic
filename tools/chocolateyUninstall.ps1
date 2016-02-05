$programs = [environment]::GetFolderPath([environment+specialfolder]::Programs)
$shortcutPath = Join-Path "$programs" "Kitematic"
$shortcutFilePath = Join-Path $shortcutPath "Kitematic.lnk"

if ((Test-Path $shortcutFilePath)) {
  del $shortcutFilePath
}

if ((Get-ChildItem $shortcutPath -force | Select-Object -First 1 | Measure-Object).Count -eq 0) {
  rd $shortcutPath
}
