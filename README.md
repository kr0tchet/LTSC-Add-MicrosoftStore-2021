# Add Store to Windows 10 Enterprise LTSC  
For Windows 10 Enterprise LTSC 2021  

This is the updated version which includes the latest version of Store app as of 7/8/2023. Probably kinda buggy but it might work.

Alternatively, you can do "wsreset -i" to install Microsoft Store aswell.

[Download](https://github.com/kr0tchet/LTSC-Add-MicrosoftStore-2021/archive/refs/heads/master.zip)  
## To install, run Add-Store.cmd as Administrator  
If you do not want App Installer / Purchase App / Xbox identity, delete each one appxbundle before running to install. However, if you plan on installing games or any app with in-purchase options, you should include everything.  
If the store still will not function, reboot. If still not working, open the command prompt as the administrator and run the following command, then reboot once more.  
```PowerShell -ExecutionPolicy Unrestricted -Command "& {$manifest = (Get-AppxPackage Microsoft.WindowsStore).InstallLocation + '\AppxManifest.xml' ; Add-AppxPackage -DisableDevelopmentMode -Register $manifest}"```    

## Post installation
Once everything is properly installed, run Microsoft Store and check for updates, if found any, install all of them.

## Addition troubleshooting    
>Right click start  
Select Run  
Type in: WSReset.exe  
This will clear the cache if needed.  
  
