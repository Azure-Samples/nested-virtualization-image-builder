source "hyperv-iso" "windows-server-2022" {
    iso_url = "https://software-download.microsoft.com/download/sg/20348.169.210806-2348.fe_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso"
    iso_checksum = "sha256:4f1457c4fe14ce48c9b2324924f33ca4f0470475e6da851b39ccbf98f44e7852"

    floppy_files = ["autounattend.xml"]
    vm_name = "packer-win2022"
    boot_wait = "5s"
    disk_size = "10240"
    headless = false
    winrm_password = "packer"
    winrm_username = "Administrator"
    communicator = "winrm"
    winrm_use_ssl = true
    winrm_insecure = true
    winrm_timeout = "4h"
    shutdown_timeout = "30m"
    disable_shutdown = true 
    skip_compaction = true
    switch_name = "VmNAT"
    generation = 1
    use_fixed_vhd_format = true
    differencing_disk = false
}

build {
  sources = ["sources.hyperv-iso.windows-server-2022"]

  provisioner "powershell" {
    script = "scripts/win-updates.ps1"
  }
  
  provisioner "powershell" {
    script = "scripts/setup.ps1"
  }

  provisioner "windows-restart" {
    restart_timeout = "30m"
  }

  provisioner "powershell" {
    script = "scripts/install-vm-agent.ps1"
  }

  provisioner "powershell" {
    script = "scripts/add-web-server.ps1"
  }

  provisioner "powershell" {
    script = "scripts/set-boot-config.cmd"
  }

  provisioner "powershell" {
    script = "scripts/collect-crash-events.ps1"
  }

  provisioner "powershell" {
    script = "scripts/sysprep.ps1"
  }
}