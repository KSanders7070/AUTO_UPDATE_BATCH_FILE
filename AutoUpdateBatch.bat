@echo off
setlocal enabledelayedexpansion

:: Set SCRIPT_NAME to the name of this batch file script
	set THIS_VERSION=2.0rc1

:: Set SCRIPT_NAME to the name of this batch file script
	set SCRIPT_NAME=Auto Update Testing

:: Set GH_USER_NAME to your GitHub username here
	set GH_USER_NAME=KSanders7070

:: Set GH_REPO_NAME to your GitHub repository name here
	set GH_REPO_NAME=BATCH_FILE_VERSION_CHECK

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

TITLE !SCRIPT_NAME! (v!THIS_VERSION!)

:SetUpTempDir

	:: Setting up the Temp Directory
	CD /D "%temp%"
		IF exist "!GH_REPO_NAME!-UDPATE" RD /S /Q "!GH_REPO_NAME!-UDPATE"
		MD "!GH_REPO_NAME!-UDPATE"
		
	CD /D "!GH_REPO_NAME!-UDPATE"

:GetLatestVerNum

	:: URL to fetch JSON data from GitHub API
	set "URL_TO_DOWNLOAD=https://api.github.com/repos/!GH_USER_NAME!/!GH_REPO_NAME!/releases/latest"
	
	:: Use curl to fetch the JSON data
	curl -s "%URL_TO_DOWNLOAD%">response.json

	:: Notes for future developemnt:
	:: 	Searches for lines containing the text "tag_name", and extract the values associated with "tag_name" into a variable named LATEST_VERSION.
	:: 		Note-In this .json, there should only be one line with "tag_name" in it.
	:: 	The command inside the single quotes ('...') reads the response.json file using the type command and pipes the output to find /i "tag_name"
	:: 	which searches for lines containing the case-insensitive text "tag_name".
	:: 	The rest of the !line! code is just striping the data way from the actual version number.
	for /f "tokens=*" %%A in ('type response.json ^| find /i "tag_name"') do (
		set "line=%%A"
		set "line=!line:*"tag_name": =!"
		set "line=!line:~2,-2!"
		set "LATEST_VERSION=!line!"
	)

:DoYouHaveLatest
	
	:: If the current version matches the latest version available, contine on with normal code.
	if "!THIS_VERSION!"=="!LATEST_VERSION!" (
		
		set VERSION_STATUS=---Running Latest Version---
			TITLE !SCRIPT_NAME! (v!THIS_VERSION!)       !VERSION_STATUS!
		goto UpdateCleanUp
	)
	
	set VERSION_STATUS=---VERSION v!LATEST_VERSION! AVAILABLE---
		TITLE !SCRIPT_NAME! (v!THIS_VERSION!)       !VERSION_STATUS!

:UpdateAvailablePrompt

	cls
	
	ECHO.
	ECHO.
	ECHO * * * * * * * * * * * * *
	ECHO     UPDATE AVAILABLE
	ECHO * * * * * * * * * * * * *
	ECHO.
	ECHO.
	ECHO YOUR VERSION:   !THIS_VERSION!
	ECHO GITHUB VERSION: !LATEST_VERSION!
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

	SET UPDATE_CHOICE=NO_CHOICE_MADE

	SET /p UPDATE_CHOICE=Please type either A, M, or C and press Enter: 
		if /I %UPDATE_CHOICE%==A GOTO AUTO_UPDATE
		if /I %UPDATE_CHOICE%==M GOTO MANUAL_UPDATE
		if /I %UPDATE_CHOICE%==C GOTO UpdateCleanUp
		if /I %UPDATE_CHOICE%==NO_CHOICE_MADE GOTO UpdateAvailablePrompt
			echo.
			echo.
			echo.
			echo.
			echo  %UPDATE_CHOICE% IS NOT A RECOGNIZED RESPONSE. Try again.
			echo.
			GOTO UpdateAvailablePrompt
	
:AUTO_UPDATE
	
	:: Sets the directory that this batch file is currently in.
	SET CUR_BAT_DIR=%~dp0
	
	:: Sets the name of this batch file to this variable.
	SET BAT_NAME=%~nx0
	
	:: Creates the URL to download the latest version of this batch file.
	set FILE_URL=https://github.com/!GH_USER_NAME!/!GH_REPO_NAME!/releases/download/v!LATEST_VERSION!/!BAT_NAME!
	
	:: Sets the download file name to the same name as this batch file.
	set DOWNLOAD_FILE_NAME=!BAT_NAME!

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
	ECHO   WAIT 5 SECONDS.
	ECHO.
	ECHO   THE NEW UPDATED BATCH FILE WILL START BY ITSELF.
	ECHO.
	ECHO * * * * * * * * * * * * * * * * * * * * * * * * * * *
	ECHO.
	ECHO.
	
	PAUSE
	
	:: Creates a small batch file that will be automatically launched and will:
	::     1) Wait 5 seconds
	::     2) Call the directory of this batch file
	::     3) Will start a batch file by this same name however by the time
	::        that is called, it is likely that this batch file will be
	::        overwritten by the newly downloaded version.
	CD /d "%temp%"
		(
		ECHO @ECHO OFF
		ECHO.
		ECHO Getting newest update; Please standby.
		ECHO.
		ECHO.
		ECHO TIMEOUT 5
		ECHO CD /d "%~dp0"
		ECHO START %~nx0
		ECHO EXIT
		)>TempBatWillDelete.bat
	
	START "Update Waiting Message" TempBatWillDelete.bat
	
	CD /d "!CUR_BAT_DIR!"
		curl -o %DOWNLOAD_FILE_NAME% -L %FILE_URL%
	EXIT

:MANUAL_UPDATE
	
	set GH_LATEST_RLS_PAGE=https://github.com/!GH_USER_NAME!/!GH_REPO_NAME!/releases/latest
	
	CLS
	
	START "" "!GH_LATEST_RLS_PAGE!"
	
	ECHO.
	ECHO.
	ECHO GO TO THE FOLLOWING WEBSITE, DOWNLOAD AND USE THE LATEST VERSION OF %~nx0
	ECHO.
	ECHO    !GH_LATEST_RLS_PAGE!
	ECHO.
	ECHO Press any key to exit...
	
	pause>nul
	
	exit

:UpdateCleanUp

	cls
	
	CD /D "%temp%"
		IF exist "!GH_REPO_NAME!-UDPATE" RD /S /Q "!GH_REPO_NAME!-UDPATE"

	:: Ensures the directory is back to where this batch file is hosted.
	CD /D "%~dp0"

endlocal 

:RestOfCode
:: This is where you start your normal code...
	
	CLS

	:: Here is where your normal code will go after the update process is done.
	ECHO.
	ECHO.
	ECHO VERSION CHECK COMPLETE, Do some other stuff now.
	ECHO.
	ECHO.

	pause
	
	EXIT


