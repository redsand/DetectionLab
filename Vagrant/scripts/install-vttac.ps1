# Purpose: Installs HAWK vTTAC on the host
# Note: by default, osquery will be configured to connect to the Fleet server on the "logger" host via TLS.
# If you would like to have osquery run without TLS & Fleet, uncomment line 15 and comment lines 21-30.

# if service does not exist..
$serviceName = 'hawkvttac'
If (Get-Service $serviceName -ErrorAction SilentlyContinue) {
	Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) vTTAC already installed."
} Else {

	Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Installing vTTAC..."

	$file = "C:\Users\vagrant\AppData\Local\Temp\hawkvttac.exe"
	$exitCode = [Diagnostics.Process]::Start($file,"/S").WaitForExit(-1)

	$file = $Env:Programfiles + "\HAWK\vTTAC\hawkvttac.cfg"
	(Get-Content $file) | Where-Object {$_ -notmatch 'HTTPHost'} | Set-Content $file
	(Get-Content $file) | Where-Object {$_ -notmatch 'RemoteHost'} | Set-Content $file
	(Get-Content $file) | Where-Object {$_ -notmatch 'RemoteService'} | Set-Content $file
	(Get-Content $file) | Where-Object {$_ -notmatch 'HTTPSSLVerifyPeer'} | Set-Content $file
	(Get-Content $file) | Where-Object {$_ -notmatch 'HTTPSSLVerifyHost'} | Set-Content $file

	# replace logging engine line and HTTPHost line
	Add-Content $file "HTTPHost=https://192.168.38.111:8080/API/1.1/"
	Add-Content $file "RemoteHost=192.168.38.111"
	Add-Content $file "RemoteService=TCP"
	Add-Content $file "RemoteIDS=192.168.38.105"
	Add-Content $file "RemoteIDSMode=XTunnel"
	Add-Content $file "BPF=(not port 443)"
	Add-Content $file "HTTPSSLVerifyPeer=False"
	Add-Content $file "HTTPSSLVerifyHost=False"

	# restart service
	Restart-Service -Name $serviceName

	Get-Service -Name $serviceName

	Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Installing vTTAC completed."

}

