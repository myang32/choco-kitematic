"Running tests"
$ErrorActionPreference = "Stop"
$version = $env:APPVEYOR_BUILD_VERSION -replace('\.[^.\\/]+$')

"TEST: Version $version in kitematic.nuspec file should match"
[xml]$spec = Get-Content kitematic.nuspec
if ($spec.package.metadata.version.CompareTo($version)) {
  Write-Error "FAIL: rong version in nuspec file!"
}

"TEST: Package should contain only install script"
Add-Type -assembly "system.io.compression.filesystem"
$zip = [IO.Compression.ZipFile]::OpenRead("$pwd\kitematic.$version.nupkg")
if ($zip.Entries.Count -ne 5) {
  Write-Error "FAIL: Wrong count in nupkg!"
}
$zip.Dispose()

"TEST: Installation of package should work"
. choco install -y kitematic -source .

"TEST: Binary is installed"
if (-Not (Test-Path "c:\ProgramData\chocolatey\lib\kitematic\tools\Kitematic.exe")) {
  Write-Error "FAIL: Binary kitematic.exe is missing!"
}

"TEST: Shortcut is installed"
$programs = [environment]::GetFolderPath([environment+specialfolder]::Programs)
if (-Not (Test-Path "$programs\Kitematic\Kitematic.lnk")) {
  Write-Error "FAIL: Shortcut for Kitematic is missing!"
}

"TEST: Uninstall show remove the binary"
. choco uninstall kitematic
try {
  . kitematic
  Write-Error "FAIL: kitematic binary still found"
} catch {
  Write-Host "PASS: kitematic not found"
}

"TEST: Binary is no longer installed"
if (Test-Path "c:\ProgramData\chocolatey\lib\kitematic\tools\Kitematic.exe") {
  Write-Error "FAIL: Binary kitematic.exe is still installed!"
}

"TEST: Shortcut is no longer installed"
$programs = [environment]::GetFolderPath([environment+specialfolder]::Programs)
if (Test-Path "$programs\Kitematic\Kitematic.lnk") {
  Write-Error "FAIL: Shortcut for Kitematic is still installed!"
}

"TEST: Finished"
