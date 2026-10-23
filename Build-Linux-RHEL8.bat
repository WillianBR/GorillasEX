@echo off
REM GorillasEX Linux ELF64 build via disposable Docker container.
setlocal EnableExtensions
pushd "%~dp0" || exit /b 1

REM Dockerfile is located under docker/. The context is this project root.
docker image inspect gorillasex-builder:rhel8-qb64pe-4.6.0 >nul 2>&1
if errorlevel 1 (
    echo Building Docker builder image (first use only)...
    docker build --progress=plain -f docker\Dockerfile.rhel8 -t gorillasex-builder:rhel8-qb64pe-4.6.0 .
    if errorlevel 1 goto error
)

echo Compiling ELF64 with Docker; container will be removed after build...
docker run --rm --platform linux/amd64 --mount "type=bind,source=%CD%,target=/project" gorillasex-builder:rhel8-qb64pe-4.6.0
if errorlevel 1 goto error

echo.
echo Output: bin\GorillasEX-linux-x86_64
echo Output: bin\GorillasEX-linux-x86_64.sha256
popd
exit /b 0

:error
echo Build failed. Check log above.
popd
exit /b 1
