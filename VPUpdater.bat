@echo off
echo -----------------------------
echo Videopad Video Editor Updater
echo -----------------------------

FOR /F "skip=2 tokens=2,*" %%A IN ('reg.exe QUERY "HKCU\Software\NCH Software\VideoPad\Settings" /v "CurrentVersion"') DO set "VPVersion=%%B"
set VPVersion=%VPVersion:+=%
echo Detected Videopad Version: %VPVersion%

set VPVersion=%VPVersion:.=%
::echo Parsed installed version: %VPVersion%

echo Downloading installer...
start /b /w ./curl-7.65.3-win64-mingw/bin/curl.exe https://www.nchsoftware.com/videopad/vppsetup.exe -A "Mozilla" -# --output vppsetup.exe

FOR /F %%A IN ('start /b /w ./Sigcheck/sigcheck.exe -q -n vppsetup.exe') DO set "NewVersion=%%A"
set NewVersion=%NewVersion:+=%
echo Detected installer version: %NewVersion%

set NewVersion=%NewVersion:.=%
::echo Parsed installer version: %NewVersion%

IF /I %VPVersion% LSS %NewVersion% (goto Update) ELSE (goto DUpdate)
    
:Update	
  echo Running installer...
  start /w vppsetup.exe
  del "C:\Users\%userprofile%\Desktop\NCH Suite.lnk"
  goto End

:DUpdate
  echo Latest version already installed

:End
  echo Deleting installer...
  del vppsetup.exe
  echo Done.
  pause