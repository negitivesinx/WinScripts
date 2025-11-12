echo off
REM start off in the directory
cd "C:\Program Files\Windows Defender\"
REM update windows
powershell start-process powershell 'install-windowsupdate -acceptall -ignorereboot ' -verb runas
REM update apps
winget upgrade --all --disable-interactivity --include-unknown
REM check windows
dISM /Online /Cleanup-Image /RestoreHealth
REM c drive clean/fix
cleanmgr C: /autoclean
cd “%ProgramFiles%\Windows Defender\"
MpCmdRun.exe -scan -scantype 3 -file C:\
ECHO Y | chkdsk C: /offlinescanandfix
defrag C: /b /v
defrag C: /h /v /x /o /u
REM d drive clean/fix
cleanmgr D: /autoclean
MpCmdRun.exe -scan -scantype 3 -file D:\
ECHO Y | chkdsk D: /offlinescanandfix
defrag D: /b /v
defrag D: /h /v /x /o /u
REM restart to do the things
shutdown -f -t 0 -r
