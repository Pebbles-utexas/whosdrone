@echo off
echo Assuming the mod is installed
chdir Skyrat-tg/Skyrat-tg-master/

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