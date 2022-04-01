Write-Host "Removing the WinHTTP proxy" 
netsh.exe winhttp reset proxy

Write-Host "Setting the disk SAN policy to Onlineall:" 

"SAN Policy=OnlineAll" | diskpart 

exit

Write-Host "Done: setup-2.ps1" 

# TODO: fix issue with diskpart exit 