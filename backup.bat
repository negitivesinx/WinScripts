:: set path="C:\Program Files"\7zip;%path%


:: rmdir %drive% /S /Q


:: variables

set drive=B:/Backup

set backupcmd=xcopy /s /c /d /e /h /i /r /k /y





echo ### Backing up Pics

%backupcmd% "C:\Users\Nathan\Pictures" "%drive%\Pictures"

echo ### Backing up Tunes

%backupcmd% "C:\Users\Nathan\Music" "%drive%\Music"

echo Backup Complete!




@pause