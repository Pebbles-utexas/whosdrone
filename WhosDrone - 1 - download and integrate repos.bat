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

set /p end=Press Enter to close the window