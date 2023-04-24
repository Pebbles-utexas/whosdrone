// Downloads the zip file of the Skyrat 13 github repository and unzips it
@echo on
curl https://codeload.github.com/Skyrat-SS13/Skyrat13/zip/refs/heads/master -L -o Skyrat13.zip
powershell Expand-Archive Skyrat13.zip
curl https://codeload.github.com/Pebbles-utexas/whosdrone/archive/refs/heads/main -L -o WhosciferDrone.zip
powershell Expand-Archive WhosciferDrone.zip -DestinationPath Skyrat-tg/

chdir Skyrat-tg

ECHO: >>"tgstation.dme"
ECHO #include "Whoscifer/WhosInit.dm">>"tgstation.dme"
ECHO #include "Whoscifer/WhosDrone.dm">>"tgstation.dme"
ECHO #include "Whoscifer/WhosMoff.dm">>"tgstation.dme"
ECHO #include "Whoscifer/WhosSlimes.dm">>"tgstation.dme"
ECHO #include "Whoscifer/WhosObjs.dm">>"tgstation.dme"
ECHO #include "Whoscifer/ItemHolders.dm">>"tgstation.dme"
ECHO #include "Whoscifer/Powers.dm">>"tgstation.dme"
ECHO #include "Whoscifer/Digistruction.dm">>"tgstation.dme"
ECHO #include "Whoscifer/Hyposynthesizer.dm">>"tgstation.dme"

set /p end=Press Enter to close the window