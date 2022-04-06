mkdir "C:\Windows\OEM\GuestAgent"
wget "https://github.com/Azure/WindowsVMAgent/releases/download/2.7.41491.1044/WindowsAzureVmAgent.2.7.41491.1044_2201181044.fre.msi" -UseBasicParsing -Outfile "C:\Windows\OEM\GuestAgent\WindowsAzureVmAgent.fre.msi"
Start-Process "C:\Windows\OEM\GuestAgent\WindowsAzureVmAgent.fre.msi" /quiet

Write-Output "Done: install-vm-agent.ps1"