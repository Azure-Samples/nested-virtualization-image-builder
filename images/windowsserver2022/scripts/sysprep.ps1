 $ProgressPreference = "SilentlyContinue"

mkdir "C:\Windows\OEM\GuestAgent"
wget "https://github.com/Azure/WindowsVMAgent/releases/download/2.7.41491.1044/WindowsAzureVmAgent.2.7.41491.1044_2201181044.fre.msi" -UseBasicParsing -Outfile "C:\Windows\OEM\GuestAgent\WindowsAzureVmAgent.fre.msi"
Start-Process "C:\Windows\OEM\GuestAgent\WindowsAzureVmAgent.fre.msi" /quiet

while($true)
{
    $service = Get-Service RdAgent -ErrorAction SilentlyContinue
    if ( $null -eq $service ) { 
	    Write-Host "RdAgent is  NOT available"
    	Start-Sleep -s 30 
    } else {
	    Write-Host "RdAgent is available"
    	break
    } 
}


Write-Output '>>> Waiting for GA Service (RdAgent) to start ...'
while ((Get-Service RdAgent).Status -ne 'Running') { Start-Sleep -s 5 }
Write-Output '>>> Waiting for GA Service (WindowsAzureGuestAgent) to start ...'
while ((Get-Service WindowsAzureGuestAgent).Status -ne 'Running') { Start-Sleep -s 5 }
Write-Output '>>> Sysprepping VM ...'
if( Test-Path $Env:SystemRoot\system32\Sysprep\unattend.xml ) {
    Remove-Item $Env:SystemRoot\system32\Sysprep\unattend.xml -Force
}
& $Env:SystemRoot\System32\Sysprep\Sysprep.exe /oobe /generalize /quiet /quit /mode:vm
while($true) {
    $imageState = (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\State).ImageState
    Write-Output $imageState
    if ($imageState -eq 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { break }
    Start-Sleep -s 5
}
Write-Output '>>> Sysprep complete ...'
Write-Output '>>> Shutting down ...'

shutdown /s /t 10 /f /d p:4:1 /c "Packer Shutdown"