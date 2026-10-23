@ECHO OFF
SETLOCAL EnableExtensions DisableDelayedExpansion

REM GorillasEX - Gera SHA-256 e pacote ZIP dos binarios.
REM Instale este arquivo em GorillasEX\bin\.
REM Requer Windows PowerShell 5.1 ou posterior.

PUSHD "%~dp0" || EXIT /B 1

IF NOT EXIST "GorillasEX.exe" (
    ECHO ERRO: GorillasEX.exe nao encontrado em "%CD%".
    POPD
    EXIT /B 1
)

REM Usa o Windows PowerShell pelo caminho do sistema; nao depende do PATH.
SET "PS=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
IF NOT EXIST "%PS%" (
    ECHO ERRO: Windows PowerShell nao encontrado.
    POPD
    EXIT /B 1
)

REM Cria uma linha SHA-256 padrao: HASH *GorillasEX.exe (ASCII sem BOM).
"%PS%" -NoProfile -NonInteractive -Command "& { $ErrorActionPreference='Stop'; $h=(Get-FileHash -LiteralPath 'GorillasEX.exe' -Algorithm SHA256).Hash.ToLowerInvariant(); [System.IO.File]::WriteAllText((Join-Path (Get-Location).Path 'GorillasEX.exe.sha256'), ($h + ' *GorillasEX.exe' + [Environment]::NewLine), [System.Text.Encoding]::ASCII) }"
IF ERRORLEVEL 1 GOTO :ERROR

REM Exclui o ZIP anterior antes de gerar o novo.
IF EXIST "GorillasEX-bin.zip" DEL /F /Q "GorillasEX-bin.zip"
IF EXIST "GorillasEX-bin.zip" GOTO :ERROR

REM Empacota todos os arquivos (nao diretorios) com nome GorillasEX.exe*.
"%PS%" -NoProfile -NonInteractive -Command "& { $ErrorActionPreference='Stop'; $files=@(Get-ChildItem -LiteralPath '.' -File | Where-Object { $_.Name -like 'GorillasEX.exe*' }); if ($files.Count -lt 2) { throw 'Arquivos de entrada insuficientes.' }; Compress-Archive -LiteralPath $files.FullName -DestinationPath 'GorillasEX-bin.zip' -CompressionLevel Optimal; Add-Type -AssemblyName System.IO.Compression.FileSystem; $zip=[System.IO.Compression.ZipFile]::OpenRead((Join-Path (Get-Location).Path 'GorillasEX-bin.zip')); try { $names=@($zip.Entries | ForEach-Object { $_.FullName }); foreach($f in $files) { if($names -notcontains $f.Name) { throw ('Arquivo ausente do ZIP: '+$f.Name) } } } finally { $zip.Dispose() } }"
IF ERRORLEVEL 1 GOTO :ERROR

ECHO.
ECHO SHA-256: "%CD%\GorillasEX.exe.sha256"
TYPE "GorillasEX.exe.sha256"
ECHO ZIP: "%CD%\GorillasEX-bin.zip"
ECHO.
POPD
EXIT /B 0

:ERROR
ECHO ERRO: falha na geracao ou verificacao do pacote binario.
POPD
EXIT /B 1
