@echo off
echo Downloading the zip file of the Skyrat-tg github repository, this may take a while so please be patient
curl https://codeload.github.com/Skyrat-SS13/Skyrat-tg/zip/refs/heads/master -L -o Skyrat-tg.zip
echo Done.
echo:
echo Unzipping the Skyrat-tg github repository, this may take a while so please be patient
powershell Expand-Archive Skyrat-tg.zip -Force
echo Done.
echo:

echo Downloading the zip file of my github repository
curl https://codeload.github.com/Pebbles-utexas/whosdrone/zip/refs/heads/main -L -o whosdrone.zip
echo Done.
echo:

echo Unzipping my github repository
powershell Expand-Archive whosdrone.zip -Force
echo Done.
echo:

echo Integrating my files into the game
move /Y whosdrone/whosdrone-main/Whoscifer Skyrat-tg/Skyrat-tg-master/
chdir Skyrat-tg/Skyrat-tg-master/

echo: >>"tgstation.dme"
echo #include "Whoscifer/WhosInit.dm">>"tgstation.dme"
echo #include "Whoscifer/WhosDrone.dm">>"tgstation.dme"
echo #include "Whoscifer/WhosMoff.dm">>"tgstation.dme"
echo #include "Whoscifer/WhosSlimes.dm">>"tgstation.dme"
echo #include "Whoscifer/WhosObjs.dm">>"tgstation.dme"
echo #include "Whoscifer/ItemHolders.dm">>"tgstation.dme"
echo #include "Whoscifer/Powers.dm">>"tgstation.dme"
echo #include "Whoscifer/Digistruction.dm">>"tgstation.dme"
echo #include "Whoscifer/Hyposynthesizer.dm">>"tgstation.dme"
echo Done.
echo:

echo Building the game into an executable file that includes my modifications
call BUILD.bat
echo Done.
echo:

echo oooooooooooooooooooooooooooooooooooooo
echo:
echo The path to the executable file is %cd%\tgstation.dmb
echo You will need to provide this path to Dream Daemon for it to load the game
echo:
echo oooooooooooooooooooooooooooooooooooooo
echo:

set /p end=Press Enter to close the window