@echo off
echo Assuming repositories are already integrated
chdir Skyrat-tg/Skyrat-tg-master/

nul findstr /c:"#include ""Whoscifer/WhosInit.dm""" tgstation.dme && (
  echo include statements were found.
  echo No action needed
echo:
) || (
  echo include statements were NOT found.
  echo Adding include statements for my files to the game 
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
)

set /p end=Press Enter to close the window