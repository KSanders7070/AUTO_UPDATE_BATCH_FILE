# BATCH_FILE_VERSION_CHECK
This BATCH File code is intended to be used at the start of any of your BATCH files that you host on GitHub. It will perform a check each time it is Launched to see if there is a new version on GitHub to be downloaded prior to use.

Developers should replace the data contained in the first 4 variables accordingly:
```
:: Set SCRIPT_NAME to the name of this batch file script
	set CURRENT_VERSION=2.0

:: Set SCRIPT_NAME to the name of this batch file script
	set SCRIPT_NAME=Auto Update Testing

:: Set GH_USER_NAME to your GitHub username here
	set GH_USER_NAME=KSanders7070

:: Set GH_REPO_NAME to your GitHub repository name here
	set GH_REPO_NAME=AUTO_UPDATE_BATCH_FILE
```

and then place their normal code below the :RestOfCode label.
