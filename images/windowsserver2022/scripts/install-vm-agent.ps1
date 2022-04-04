mkdir "C:\Windows\OEM\GuestAgent"
wget "https://go.microsoft.com/fwlink/?linkid=394789&clcid=0x409" -UseBasicParsing -Outfile "C:\Windows\OEM\GuestAgent\VMAgentMSI.msi"
Start-Process "C:\Windows\OEM\GuestAgent\VMAgentMSI.msi" \quiet