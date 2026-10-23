@ECHO OFF
SETLOCAL EnableExtensions DisableDelayedExpansion

REM GorillasEX - Source package generator for Windows 11.
REM Place this file in the project root and execute it.
REM The ZIP includes the GorillasEX root directory, except .git and bin.

FOR %%I IN ("%~dp0.") DO SET "PROJECT=%%~nxI"
FOR %%I IN ("%~dp0..") DO SET "PARENT=%%~fI"
SET "ZIP=%PARENT%\%PROJECT%-source.zip"
SET "TEMPZIP=%PARENT%\%PROJECT%-source.tmp.zip"

IF NOT EXIST "%SystemRoot%\System32\tar.exe" (
    ECHO ERROR: Windows BSD tar not found.
    EXIT /B 1
)

REM Deliberately bypass PATH: use the Windows bundled BSD tar.
IF NOT EXIST "%SystemRoot%\System32\tar.exe" >NUL 2>&1
IF ERRORLEVEL 1 (
    ECHO ERROR: tar.exe was not found on PATH.
    EXIT /B 1
)

IF EXIST "%TEMPZIP%" DEL /Q "%TEMPZIP%"

ECHO Project: %PROJECT%
ECHO Output : %ZIP%
ECHO.

REM Use Windows BSD tar by absolute path; do not depend on PATH.
REM Exclusions apply recursively to directories named .git or bin.
"%SystemRoot%\System32\tar.exe" --format=zip -c -f "%TEMPZIP%" --exclude=".git" --exclude="bin" -C "%PARENT%" "%PROJECT%"
IF ERRORLEVEL 1 (
    ECHO ERROR: ZIP creation failed.
    IF EXIST "%TEMPZIP%" DEL /Q "%TEMPZIP%"
    EXIT /B 1
)

REM Check that the resulting archive can be listed.
"%SystemRoot%\System32\tar.exe" -t -f "%TEMPZIP%" >NUL
IF ERRORLEVEL 1 (
    ECHO ERROR: ZIP verification failed.
    DEL /Q "%TEMPZIP%"
    EXIT /B 1
)

IF EXIST "%ZIP%" DEL /Q "%ZIP%"
MOVE /Y "%TEMPZIP%" "%ZIP%" >NUL
IF ERRORLEVEL 1 (
    ECHO ERROR: Could not move the ZIP to its final name.
    EXIT /B 1
)

ECHO.
ECHO ZIP created successfully:
ECHO %ZIP%
EXIT /B 0
