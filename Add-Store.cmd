@echo off
for /f "tokens=6 delims=[]. " %%G in ('ver') do if %%G lss 19041 goto :version
%windir%\system32\reg.exe query "HKU\S-1-5-19" 1>nul 2>nul || goto :uac
setlocal enableextensions
if /i "%PROCESSOR_ARCHITECTURE%" equ "AMD64" (set "arch=x64") else (set "arch=x86")
cd /d "%~dp0"

if not exist "*WindowsStore*.appxbundle" goto :nofiles
if not exist "*WindowsStore*.xml" goto :nofiles

for /f %%i in ('dir /b *WindowsStore*.appxbundle 2^>nul') do set "Store=%%i"
for /f %%i in ('dir /b *NET.Native.Framework*1.6*.appx 2^>nul ^| find /i "x64"') do set "Framework6X64=%%i"
for /f %%i in ('dir /b *NET.Native.Framework*1.6*.appx 2^>nul ^| find /i "x86"') do set "Framework6X86=%%i"
for /f %%i in ('dir /b *NET.Native.Framework*2.2*.appx 2^>nul ^| find /i "x64"') do set "FrameworkII6X64=%%i"
for /f %%i in ('dir /b *NET.Native.Framework*2.2*.appx 2^>nul ^| find /i "x86"') do set "FrameworkII6X86=%%i"
for /f %%i in ('dir /b *NET.Native.Runtime*1.6*.appx 2^>nul ^| find /i "x64"') do set "Runtime6X64=%%i"
for /f %%i in ('dir /b *NET.Native.Runtime*1.6*.appx 2^>nul ^| find /i "x86"') do set "Runtime6X86=%%i"
for /f %%i in ('dir /b *NET.Native.Runtime*2.2*.appx 2^>nul ^| find /i "x64"') do set "RuntimeII6X64=%%i"
for /f %%i in ('dir /b *NET.Native.Runtime*2.2*.appx 2^>nul ^| find /i "x86"') do set "RuntimeII6X86=%%i"
for /f %%i in ('dir /b *Microsoft.UI.Xaml.*2.4*.appx 2^>nul ^| find /i "x64"') do set "XamlOld6X64=%%i"
for /f %%i in ('dir /b *Microsoft.UI.Xaml.*2.4*.appx 2^>nul ^| find /i "x86"') do set "XamlOld6X86=%%i"
for /f %%i in ('dir /b *Microsoft.UI.Xaml.*2.7*.appx 2^>nul ^| find /i "x64"') do set "Xaml6X64=%%i"
for /f %%i in ('dir /b *Microsoft.UI.Xaml.*2.7*.appx 2^>nul ^| find /i "x86"') do set "Xaml6X86=%%i"
for /f %%i in ('dir /b *VCLibs*140*_*.appx 2^>nul ^| find /i "x64"') do set "VCLibsX64=%%i"
for /f %%i in ('dir /b *VCLibs*140*_*.appx 2^>nul ^| find /i "x86"') do set "VCLibsX86=%%i"
for /f %%i in ('dir /b *VCLibs*140*_*.appx 2^>nul ^| find /i "x64"') do set "VCLibsX64=%%i"
for /f %%i in ('dir /b *VCLibs*140*_*.appx 2^>nul ^| find /i "x86"') do set "VCLibsX86=%%i"

if exist "*StorePurchaseApp*.appxbundle" if exist "*StorePurchaseApp*.xml" (
for /f %%i in ('dir /b *StorePurchaseApp*.appxbundle 2^>nul') do set "PurchaseApp=%%i"
)
if exist "*DesktopAppInstaller*.appxbundle" if exist "*DesktopAppInstaller*.xml" (
for /f %%i in ('dir /b *DesktopAppInstaller*.appxbundle 2^>nul') do set "AppInstaller=%%i"
)
if exist "*XboxIdentityProvider*.appxbundle" if exist "*XboxIdentityProvider*.xml" (
for /f %%i in ('dir /b *XboxIdentityProvider*.appxbundle 2^>nul') do set "XboxIdentity=%%i"
)

if /i %arch%==x64 (
set "DepStore=%VCLibsX64%,%VCLibsX86%,%Framework6X64%,%Framework6X86%,%FrameworkII6X64%,%FrameworkII6X86%,%Runtime6X64%,%Runtime6X86%,%RuntimeII6X64%,%RuntimeII6X86%,%XamlOld6X64%,%XamlOld6X86%,%Xaml6X64%,%Xaml6X86%"
set "DepPurchase=%VCLibsX64%,%VCLibsX86%,%Framework6X64%,%Framework6X86%,%Runtime6X64%,%Runtime6X86%"
set "DepXbox=%VCLibsX64%,%VCLibsX86%,%Framework6X64%,%Framework6X86%,%Runtime6X64%,%Runtime6X86%"
set "DepInstaller=%VCLibsX64%,%VCLibsX86%,%VCLibsUWPX86%"
) else (
set "DepStore=%VCLibsX86%,%Framework6X86%,%FrameworkII6X86%,%Runtime6X86%,%RuntimeII6X86%,%XamlOld6X86%,%Xaml6X86%"
set "DepPurchase=%VCLibsX86%,%Framework6X86%,%Runtime6X86%"
set "DepXbox=%VCLibsX86%,%Framework6X86%,%Runtime6X86%"
set "DepInstaller=%VCLibsX86%,%VCLibsUWPX86%"
)

for %%i in (%DepStore%) do (
if not exist "%%i" goto :nofiles
)

set "PScommand=PowerShell -NoLogo -NoProfile -NonInteractive -InputFormat None -ExecutionPolicy Bypass"

echo.
echo ============================================================
echo Adding Microsoft Store (version 22303.1401.5.0) and it's dependencies
echo ============================================================
echo.
1>nul 2>nul %PScommand% Add-AppxProvisionedPackage -Online -PackagePath %Store% -DependencyPackagePath %DepStore% -LicensePath Microsoft.WindowsStore_8wekyb3d8bbwe.xml
for %%i in (%DepStore%) do (
%PScommand% Add-AppxPackage -Path %%i
)
%PScommand% Add-AppxPackage -Path %Store%

if defined PurchaseApp (
echo.
echo ============================================================
echo Adding Store Purchase App
echo ============================================================
echo.
1>nul 2>nul %PScommand% Add-AppxProvisionedPackage -Online -PackagePath %PurchaseApp% -DependencyPackagePath %DepPurchase% -LicensePath Microsoft.StorePurchaseApp_8wekyb3d8bbwe.xml
%PScommand% Add-AppxPackage -Path %PurchaseApp%
)
if defined AppInstaller (
echo.
echo ============================================================
echo Adding App Installer
echo ============================================================
echo.
1>nul 2>nul %PScommand% Add-AppxProvisionedPackage -Online -PackagePath %AppInstaller% -DependencyPackagePath %DepInstaller% -LicensePath Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.xml
%PScommand% Add-AppxPackage -Path %AppInstaller%
)
if defined XboxIdentity (
echo.
echo ============================================================
echo Adding Xbox Identity Provider
echo ============================================================
echo.
1>nul 2>nul %PScommand% Add-AppxProvisionedPackage -Online -PackagePath %XboxIdentity% -DependencyPackagePath %DepXbox% -LicensePath Microsoft.XboxIdentityProvider_8wekyb3d8bbwe.xml
%PScommand% Add-AppxPackage -Path %XboxIdentity%
)
goto :fin

:uac
echo.
echo ============================================================
echo Error: Run the script as administrator
echo ============================================================
echo.
echo.
echo Press any key to Exit
pause >nul
exit

:version
echo.
echo ============================================================
echo Error: This pack is for Windows 10 version 20H1 and later
echo You can obtain the original version for LTSC 2019 here:
echo https://github.com/kkkgo/LTSC-Add-MicrosoftStore
echo or LTSB 2016 here (LTSB 2015 not supported):
echo https://github.com/kkkgo/LTSB-Add-MicrosoftStore
echo ============================================================
echo.
echo.
echo Press any key to Exit
pause >nul
exit

:nofiles
echo.
echo ============================================================
echo Error: Required files are missing in the current directory
echo ============================================================
echo.
echo.
echo Press any key to Exit
pause >nul
exit

:fin
echo.
echo ============================================================
echo Done
echo ============================================================
echo.
echo Press any Key to Exit.
pause >nul
exit
