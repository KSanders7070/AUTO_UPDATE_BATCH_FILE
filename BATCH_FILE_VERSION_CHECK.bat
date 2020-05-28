@echo off

:version_chk

@rem Special Thanks to COMPO over at StackOverflow: https://stackoverflow.com/questions/61803141/batch-file-delete-folder-contents-and-the-parent-folder

@rem Create a "Version Check" file in your BATCH File GitHub code page such as the one found below and paste it in the GITHUB_VERSION_CHK_URL area.
@rem Paste the GitHub releases page for your BATCH file in the BATCH_FILE_RELEASES_URL area.
@rem Be sure to format the text found in the Version Check file as such: VERSION-(actual version name) .... Example: VERSION-1.1.2-RC
@rem Be sure to always update the Version Check page and the USER_VER variable below prior to posting every update. Do NOT include the "VERSION-" in this variable.
@rem Use the following as an example

@rem Set your version number here. Must be same case as on the version_check page.
SET USER_VER=1.2

@rem Set your version check URL here
SET GITHUB_VERSION_CHK_URL=https://github.com/KSanders7070/BATCH_FILE_VERSION_CHECK/blob/master/Version_Check

@rem Set your BATCH File GitHub releases URL here
SET BATCH_FILE_RELEASES_URL=https://github.com/KSanders7070/BATCH_FILE_VERSION_CHECK/releases

@rem The rest of the code shouldn't have to be changed for any of your future BATCH Files.

ECHO.
ECHO.
ECHO * * * * * * * * * * * * *
ECHO  CHECKING FOR UPDATES...
ECHO * * * * * * * * * * * * *
ECHO.
ECHO.

@REM Checks to see if the Temp BATCH File from a previous update is still there. If it is, it will be deleted here.

CD "%temp%"
IF Not Exist TempBatWillDelete.bat goto MK_TEMP_FOLDER
	DEL /Q TempBatWillDelete.bat

:MK_TEMP_FOLDER

If Not Exist "%temp%\VersionCheckWillDelete\" MD "%temp%\VersionCheckWillDelete"

cd "%temp%\VersionCheckWillDelete"

powershell -Command "Invoke-WebRequest %GITHUB_VERSION_CHK_URL% -OutFile 'version_check.HTML'"

For /F "Tokens=3 Delims=><" %%G In ('%__AppDir__%findstr.exe ">VERSION-" "version_check.html"') Do For /F "Tokens=1* Delims=-" %%H In ("%%G") Do Set "GH_VER=%%I"

If "%USER_VER%" == "%GH_VER%" GOTO RMDIR

:UPDATE_AVAIL

CLS

cd "%temp%"
rd /s /q "%temp%\VersionCheckWillDelete\"

ECHO.
ECHO.
ECHO * * * * * * * * * * * * *
ECHO     UPDATE AVAILABLE
ECHO * * * * * * * * * * * * *
ECHO.
ECHO.
ECHO GITHUB VERSION: %GH_VER%
ECHO YOUR VERSION:   %USER_VER%
ECHO.
ECHO.
ECHO.
ECHO  CHOICES:
ECHO.
ECHO     A   -   AUTOMATICALLY UPDATE THE BATCH FILE YOU ARE USING NOW.
ECHO.
ECHO     M   -   MANUALLY DOWNLOAD THE NEWEST BATCH FILE UPDATE AND USE THAT FILE.
ECHO.
ECHO     C   -   CONTINUE USING THIS FILE.
ECHO.
ECHO.
ECHO.
ECHO NOTE: IF YOU HAVE ATTMEPTED TO AUTOATMICALLY UPDATE ALREADY AND YOU CONTINUE
ECHO       TO GET THIS UPDATE SCREEN, PLEASE UTILIZE THE MANUAL UPDATE OPTION.
ECHO.
ECHO.
ECHO.

:UPDATE_CHOICE

SET UPDATE_CHOICE=UPDATE_METHOD_NOT_SELECTED

	SET /p UPDATE_CHOICE=Please type either A, M, or C and press Enter: 
		if /I %UPDATE_CHOICE%==A GOTO AUTO_UPDATE
		if /I %UPDATE_CHOICE%==M GOTO MANUAL_UPDATE
		if /I %UPDATE_CHOICE%==C GOTO CONTINUE
		if /I %UPDATE_CHOICE%==UPDATE_METHOD_NOT_SELECTED GOTO UPDATE_CHOICE
			echo.
			echo.
			echo.
			echo.
			echo  %UPDATE_CHOICE% IS NOT A RECOGNIZED RESPONSE. Try again.
			echo.
			GOTO UPDATE_CHOICE

:AUTO_UPDATE

CLS

ECHO.
ECHO.
ECHO * * * * * * * * * * * * * * * * * * * * * * * * * * *
ECHO.
ECHO   PRESS ANY KEY TO START THE AUTOMATIC UPDATE.
ECHO.
ECHO.
ECHO   THIS SCREEN WILL CLOSE.
ECHO.
ECHO   WAIT 5 SECONDS
ECHO.
ECHO   THE NEW UPDATED BATCH FILE WILL START BY ITSELF.
ECHO.
ECHO * * * * * * * * * * * * * * * * * * * * * * * * * * *
ECHO.
ECHO.

PAUSE

CD "%temp%"

ECHO @ECHO OFF >> TempBatWillDelete.bat
ECHO TIMEOUT 5 >> TempBatWillDelete.bat
ECHO CD "%~dp0" >> TempBatWillDelete.bat
ECHO START %~nx0 >> TempBatWillDelete.bat
ECHO EXIT >> TempBatWillDelete.bat

START /MIN TempBatWillDelete.bat

CD "%~dp0"

powershell -Command "Invoke-WebRequest %BATCH_FILE_RELEASES_URL%/download/v%GH_VER%/%~nx0 -OutFile '%~nx0'"

EXIT /b

:MANUAL_UPDATE

CLS

START "" "%BATCH_FILE_RELEASES_URL%"

ECHO.
ECHO.
ECHO GO TO THE FOLLOWING WEBSITE, DOWNLOAD AND USE THE LATEST VERSION OF %~nx0
ECHO.
ECHO.
ECHO    %BATCH_FILE_RELEASES_URL%
ECHO.
ECHO.
ECHO.
ECHO.
ECHO NOTE: PRESSING ANY KEY NOW WILL QUIT THIS VERSION OF THE BATCH FILE.
ECHO.
ECHO.

PAUSE

EXIT /b

:RMDIR

CLS

cd "%temp%"
rd /s /q "%temp%\VersionCheckWillDelete\"

:CONTINUE

ECHO YOU ARE RUNNING THE MOST UP TO DATE BATCH FILE.

PAUSE
EXIT
