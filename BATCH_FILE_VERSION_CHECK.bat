@echo off

:version_chk

@rem Special Thanks to COMPO over at StackOverflow: https://stackoverflow.com/questions/61803141/batch-file-delete-folder-contents-and-the-parent-folder

@rem Create a "Version Check" file in your BATCH File GitHub code page such as the one found below and paste it in the GITHUB_VERSION_CHK_URL area.
@rem Paste the GitHub releases page for your BATCH file in the BATCH_FILE_RELEASES_URL area.
@rem Be sure to format the text found in the Version Check file as such: VERSION-(actual version name) .... Example: VERSION-1.1.2-RC
@rem Be sure to always update the Version Check page and the USER_VER variable below prior to posting every update. Do NOT include the "VERSION-" in this variable.
@rem Use the following as an example

@rem Set your version number here. Must be same case as on the version_check page.
SET USER_VER=1.0.1

@rem Set your version check URL here
SET GITHUB_VERSION_CHK_URL=https://github.com/KSanders7070/BATCH_FILE_VERSION_CHECK/blob/master/Version_Check

@rem Set your BATCH File GitHub releases URL here
SET BATCH_FILE_RELEASES_URL=https://github.com/KSanders7070/BATCH_FILE_VERSION_CHECK/releases

@rem The rest of the code shouldn't have to be changed for any of your future BATCH Files.

ECHO * * * * * * * * * * * * *
ECHO CHECKING FOR UPDATES...
ECHO * * * * * * * * * * * * *

If Not Exist "%temp%\VersionCheckWillDelete\" MD "%temp%\VersionCheckWillDelete"

cd "%temp%\VersionCheckWillDelete"

powershell -Command "Invoke-WebRequest %GITHUB_VERSION_CHK_URL% -OutFile 'version_check.HTML'"

For /F "Tokens=3 Delims=><" %%G In ('%__AppDir__%findstr.exe ">VERSION-" "version_check.html"') Do For /F "Tokens=1* Delims=-" %%H In ("%%G") Do Set "GH_VER=%%I"

If "%USER_VER%" == "%GH_VER%" GOTO RMDIR

:UPDATE_AVAIL

CLS

cd "%temp%"
rd /s /q "%temp%\VersionCheckWillDelete\"

START "" "%BATCH_FILE_RELEASES_URL%"

ECHO * * * * * * * * * * * * *
ECHO     UPDATE AVAILABLE
ECHO * * * * * * * * * * * * *
ECHO.
ECHO.
ECHO GITHUB VERSION: %GH_VER%
ECHO YOUR VERSION:   %USER_VER%
ECHO.
ECHO.
ECHO PLEASE CLOSE THIS BATCH FILE AND GO DOWNLOAD THE MOST RECENT UPDATE AVAILABLE:
ECHO.
ECHO %BATCH_FILE_RELEASES_URL%
ECHO.
ECHO.
ECHO OR YOU MAY PRESS ANY KEY TO CONTINUE USING THIS VERSION.
ECHO.
ECHO.

PAUSE

GOTO CONTINUE

:RMDIR

CLS

cd "%temp%"
rd /s /q "%temp%\VersionCheckWillDelete\"

:CONTINUE

ECHO Start your actual BATCH Process here.

PAUSE
