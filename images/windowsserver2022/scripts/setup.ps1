netsh.exe winhttp reset proxy
Write-Host "Set the power profile to high performance" 
powercfg.exe /setactive SCHEME_MIN


Write-Host "(RDP) is enabled:"
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name fDenyTSConnections -Value 0 -Type DWord -Force

Write-Host "Set RDP port 3389:" 
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\Winstations\RDP-Tcp' -Name PortNumber -Value 3389 -Type DWord -Force

Write-Host "listening on every network interface:" 
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\Winstations\RDP-Tcp' -Name LanAdapter -Value 0 -Type DWord -Force

Write-Host "Configure network-level authentication (NLA) mode for the RDP connections" 
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name UserAuthentication -Value 1 -Type DWord -Force


Write-Host "Set the keep-alive value" 
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\Winstations\RDP-Tcp' -Name KeepAliveTimeout -Value 1 -Type DWord -Force


Write-Host "Set the reconnect options:" 
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\Winstations\RDP-Tcp' -Name fInheritReconnectSame -Value 1 -Type DWord -Force
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\Winstations\RDP-Tcp' -Name fReconnectSame -Value 0 -Type DWord -Force


Write-Host "Limit the number of concurrent connections:" 
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\Winstations\RDP-Tcp' -Name MaxInstanceCount -Value 4294967295 -Type DWord -Force

Write-Host "Configuring firewall rules" 

Write-Host "Turning on Windows Firewall on the three profiles (domain, standard, and public)" 
Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled True

Write-Host "Allowing WinRM through the three firewall profiles (domain, private, and public), and enable the PowerShell remote service" 
Enable-PSRemoting -Force
Set-NetFirewallRule -Name WINRM-HTTP-In-TCP, WINRM-HTTP-In-TCP-PUBLIC -Enabled True

Write-Host "Allowing the RDP traffic" 
Set-NetFirewallRule -Group '@FirewallAPI.dll,-28752' -Enabled True

Write-Host "Enabling the rule for file and printer sharing so the VM can respond to ping requests inside the virtual network" 
Set-NetFirewallRule -Name FPS-ICMP4-ERQ-In -Enabled True

Write-Host "Creating Rule for the Azure platform network" 
New-NetFirewallRule -DisplayName AzurePlatform -Direction Inbound -RemoteAddress 168.63.129.16 -Profile Any -Action Allow -EdgeTraversalPolicy Allow
New-NetFirewallRule -DisplayName AzurePlatform -Direction Outbound -RemoteAddress 168.63.129.16 -Profile Any -Action Allow


Write-Host "Adding WindowsFeature Web-Server" 
Add-WindowsFeature Web-Server

Write-Host "Done: setup.ps1" 