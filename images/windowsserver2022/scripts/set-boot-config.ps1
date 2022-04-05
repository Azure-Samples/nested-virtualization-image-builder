cmd.exe bcdedit.exe /set "{bootmgr}" integrityservices enable
cmd.exe bcdedit.exe /set "{default}" device partition=C:
cmd.exe bcdedit.exe /set "{default}" integrityservices enable
cmd.exe bcdedit.exe /set "{default}" recoveryenabled Off
cmd.exe bcdedit.exe /set "{default}" osdevice partition=C:
cmd.exe bcdedit.exe /set "{default}" bootstatuspolicy IgnoreAllFailures
cmd.exe bcdedit.exe /set "{bootmgr}" displaybootmenu yes
cmd.exe bcdedit.exe /set "{bootmgr}" timeout 5
cmd.exe bcdedit.exe /set "{bootmgr}" bootems yes
cmd.exe bcdedit.exe /ems "{current}" ON
cmd.exe bcdedit.exe /emssettings EMSPORT:1 EMSBAUDRATE:115200