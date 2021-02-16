# Purpose: Downloads HAWK vTTAC Agent

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Downloading the HAWK vTTAC Agent..."

$hawkRepoPath = 'C:\Users\vagrant\AppData\Local\Temp\hawkvttac.exe'

If (-not (Test-Path $hawkRepoPath))
{
    # GitHub requires TLS 1.2 as of 2/1/2018
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri "https://downloads.hawkdefense.com/agent/HAWKvTTACSetupx64-latest.exe" -OutFile $hawkRepoPath
}
else
{
    Write-Host "$hawkRepoPath already exists. Moving On."
}
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) HAWK vTTAC Agent download complete!"
