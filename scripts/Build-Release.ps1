[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$ToolsDirectory,
    [Parameter(Mandatory = $true)][string]$OutputDirectory
)
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$toolRoot = (Resolve-Path -LiteralPath $ToolsDirectory).Path
$outRoot = [System.IO.Path]::GetFullPath($OutputDirectory)
$packageName = 'Jack-The-Ripper-2.3'
$packageRoot = Join-Path $outRoot $packageName
$zipPath = Join-Path $outRoot 'Jack-The-Ripper-2.3-Windows-x64.zip'
if ((Test-Path -LiteralPath $packageRoot) -or (Test-Path -LiteralPath $zipPath)) {
    throw 'Uitvoermap of ZIP bestaat al. Kies een nieuwe uitvoermap.'
}
$executables = @('yt-dlp.exe', 'ffmpeg.exe', 'ffprobe.exe', 'deno.exe')
foreach ($name in $executables) {
    if (-not (Test-Path -LiteralPath (Join-Path $toolRoot $name) -PathType Leaf)) {
        throw "Benodigd bestand ontbreekt: $name"
    }
}
New-Item -ItemType Directory -Force -Path (Join-Path $packageRoot 'tools') | Out-Null
foreach ($name in @('JACK2.bat', 'README.md', 'CHANGELOG.txt', 'THIRD-PARTY.md')) {
    Copy-Item -LiteralPath (Join-Path $repoRoot $name) -Destination $packageRoot
}
Copy-Item -LiteralPath (Join-Path $repoRoot 'licenses') -Destination $packageRoot -Recurse
Copy-Item -LiteralPath (Join-Path $repoRoot 'tools\deno-source.json') -Destination (Join-Path $packageRoot 'tools')
$versions = [ordered]@{}
foreach ($name in $executables) {
    $destination = Join-Path $packageRoot ('tools\' + $name)
    Copy-Item -LiteralPath (Join-Path $toolRoot $name) -Destination $destination
    $argument = if ($name -in @('ffmpeg.exe', 'ffprobe.exe')) { '-version' } else { '--version' }
    $versionOutput = & $destination $argument 2>&1
    if ($LASTEXITCODE -ne 0) { throw "$name kan niet starten." }
    $versions[$name] = ($versionOutput | Select-Object -First 1).ToString()
}
$versions | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $packageRoot 'tools\versions.json') -Encoding UTF8
$checksums = Get-ChildItem -LiteralPath $packageRoot -File -Recurse | Sort-Object FullName | ForEach-Object {
    $relativePath = $_.FullName.Substring($packageRoot.Length + 1).Replace('\', '/')
    '{0}  {1}' -f (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash.ToLower(), $relativePath
}
$checksums | Set-Content -LiteralPath (Join-Path $packageRoot 'SHA256SUMS.txt') -Encoding ASCII
Compress-Archive -LiteralPath $packageRoot -DestinationPath $zipPath -CompressionLevel Optimal
$zipHash = (Get-FileHash -LiteralPath $zipPath -Algorithm SHA256).Hash.ToLower()
('{0}  {1}' -f $zipHash, [System.IO.Path]::GetFileName($zipPath)) | Set-Content -LiteralPath ($zipPath + '.sha256') -Encoding ASCII
Write-Output $zipPath
Write-Output ('SHA256: ' + $zipHash)
