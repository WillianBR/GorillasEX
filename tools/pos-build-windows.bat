@ECHO OFF
SETLOCAL EnableExtensions

REM ============================================================
REM GorillasEX - Windows Post-Build
REM Adds the .credits section to the PE64 executable.
REM ============================================================

SET "PROJECT_DIR=%~dp0.."
SET "BIN_DIR=%PROJECT_DIR%\bin"
SET "EXE=%BIN_DIR%\GorillasEX.exe"
SET "TEMP_EXE=%BIN_DIR%\GorillasEX.tmp.exe"
SET "CREDITS=%PROJECT_DIR%\docs\CREDITS.txt"
SET "VERIFY=%BIN_DIR%\credits-verify.tmp"

REM Set the location of GNU Binutils.
SET "OBJCOPY=objcopy.exe"
SET "OBJDUMP=objdump.exe"

IF NOT EXIST "%EXE%" (
    ECHO ERROR: Executable not found.
    EXIT /B 1
)

IF NOT EXIST "%CREDITS%" (
    ECHO ERROR: Credits file not found.
    EXIT /B 1
)

REM Prevent stale temporary files.
IF EXIST "%TEMP_EXE%" DEL /F /Q "%TEMP_EXE%"
IF EXIST "%VERIFY%" DEL /F /Q "%VERIFY%"

REM Check whether the section already exists.
"%OBJDUMP%" -h "%EXE%" | FINDSTR /R /C:"\.credits" >NUL

IF NOT ERRORLEVEL 1 (
    ECHO ERROR: Section .credits already exists.
    EXIT /B 1
)

REM Add custom PE section.
"%OBJCOPY%" ^
    --add-section ".credits=%CREDITS%" ^
    --set-section-flags ".credits=contents,readonly,data" ^
    "%EXE%" ^
    "%TEMP_EXE%"

IF ERRORLEVEL 1 (
    ECHO ERROR: objcopy failed.
    EXIT /B 1
)

REM Confirm that the new section exists.
"%OBJDUMP%" -h "%TEMP_EXE%" | FINDSTR /C:".credits" >NUL

IF ERRORLEVEL 1 (
    ECHO ERROR: .credits section was not created.
    EXIT /B 1
)

REM Extract the embedded contents.
"%OBJCOPY%" ^
    --dump-section ".credits=%VERIFY%" ^
    "%TEMP_EXE%"

IF ERRORLEVEL 1 (
    ECHO ERROR: Could not extract .credits.
    EXIT /B 1
)

REM Compare extracted bytes against the original file.
FC /B "%CREDITS%" "%VERIFY%" >NUL

IF ERRORLEVEL 1 (
    ECHO ERROR: Credits verification failed.
    EXIT /B 1
)

REM Remove temporary verification file.
DEL /F /Q "%VERIFY%"

REM Replace the original executable.
MOVE /Y "%TEMP_EXE%" "%EXE%" >NUL

IF ERRORLEVEL 1 (
    ECHO ERROR: Could not replace executable.
    EXIT /B 1
)

ECHO.
ECHO GorillasEX Windows Post-Build completed successfully.
ECHO Credits section embedded and verified.
ECHO.

EXIT /B 0