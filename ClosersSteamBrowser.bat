@echo off
title Closers desde Navegador y Steam - By Henry
mode con:cols=76 lines=20
color 0A
cls

:: Elevando el batch como administrador
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Solicitando permisos de administrador...
    goto UACPrompt
) else (
    goto gotAdmin
)

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    cd /d "%~dp0"

:: Confirmar que se va a habilitar el uso de Steam
:Menu1
cls
echo ----------------------------------------------------------------------------
echo Configurar Closers para Navegador y Steam
echo ----------------------------------------------------------------------------
echo Este script habilitara Closers para usarlo desde Steam y el navegador.
echo Seguro que deseas continuar? (S/N)
echo ----------------------------------------------------------------------------
set "choice=A"
set /p choice=Respuesta: 
if /i "%choice%"=="S" goto instalar
if /i "%choice%"=="N" goto fin
cls
echo ----------------------------------------------------------------------------
echo Opcion invalida. Intenta de nuevo.
echo ----------------------------------------------------------------------------
timeout /t 2 >nul
goto Menu1

:instalar
cls
echo ----------------------------------------------------------------------------
echo Preparando configuracion...
echo ----------------------------------------------------------------------------

:ClosersRuta
:: Configurar rutas por defecto
set "myclosers=C:\Closers"
set "SteamPath=%ProgramFiles%\Steam"
:: Obtener ruta de Steam del registro
for /f "tokens=2*" %%a in ('reg query "HKEY_CURRENT_USER\Software\Valve\Steam" /v SteamPath 2^>nul') do set "SteamPath=%%~b"
set "SteamPath=%SteamPath:/=\%"
:: Priorizar Steam si ya tiene Closers
if exist "%SteamPath%\steamapps\common\Closers\LAUNCHER.exe" set "myclosers=%SteamPath%\steamapps\common\Closers"
:: Buscar en discos externos (C a V, excluyendo A B Z X W Y)
for %%d in (C D E F G H I J K L M N O P Q R S T U V) do (
    if exist "%%d:\Closers\LAUNCHER.exe" set "myclosers=%%d:\Closers"
)
:: Obtener ruta del registro de Closers (navegador)
for /f "tokens=2*" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\naddiclauncherna\shell\open\command" /v "" 2^>nul') do set "myclosers1=%%~b"
:: Quitar las comillas dobles de la variable myclosers1
set "myclosers1=%myclosers1:"=%"
:: Quitar el nombre del archivo y los parametros de la variable myclosers1
set "myclosers1=%myclosers1:\LAUNCHER.exe _NA =%"
set "myclosers1=%myclosers1:~0,-2%"
:: Cambiar la variable en caso que este en el registro de windows
if exist "%myclosers1%" set "myclosers=%myclosers1%"
:: Usar la carpeta del script si contiene LAUNCHER.exe
if exist "%~dp0LAUNCHER.exe" set "myclosers=%~dp0"

echo Detectando rutas de instalacion...
timeout /t 1 >nul

if not exist "%SteamPath%\steamapps\common\Closers\Cw.exe" if not exist "%SteamPath%\steamapps\common\Closers\DAT" (
    echo Creando copia de seguridad de Steam...
    mkdir "%SteamPath%\steamapps\temp\215830" 2>nul
    attrib /s -r -h -s "%SteamPath%\steamapps\common\Closers\*" 2>nul
    attrib /s -r -h -s "%SteamPath%\steamapps\temp\215830\*" 2>nul
    move /Y "%SteamPath%\steamapps\common\Closers\BUGTRAPU-X64.DLL" "%SteamPath%\steamapps\temp\215830\" 2>nul
    move /Y "%SteamPath%\steamapps\common\Closers\CLIENT_CLOSERS*.zip" "%SteamPath%\steamapps\temp\215830\" 2>nul
    move /Y "%SteamPath%\steamapps\common\Closers\CLOSERS.EXE" "%SteamPath%\steamapps\temp\215830\" 2>nul
    move /Y "%SteamPath%\steamapps\common\Closers\LAUNCHER.exe" "%SteamPath%\steamapps\temp\215830\" 2>nul
    move /Y "%SteamPath%\steamapps\common\Closers\MSVCR100.DLL" "%SteamPath%\steamapps\temp\215830\" 2>nul
    move /Y "%SteamPath%\steamapps\common\Closers\PATCHER_CODE.LUA" "%SteamPath%\steamapps\temp\215830\" 2>nul
    move /Y "%SteamPath%\steamapps\common\Closers\steam_appid.txt" "%SteamPath%\steamapps\temp\215830\" 2>nul
    move /Y "%SteamPath%\steamapps\common\Closers\VER_CLOSERS.DLL" "%SteamPath%\steamapps\temp\215830\" 2>nul
)

if not exist "%myclosers%\Cw.exe" if not exist "%myclosers%\DAT" (
    echo Creando copia de seguridad de Closers...
    mkdir "%temp%\215830" 2>nul
    attrib /s -r -h -s "%myclosers%\*" 2>nul
    attrib /s -r -h -s "%temp%\215830\*" 2>nul
    move /Y "%myclosers%\BUGTRAPU-X64.DLL" "%temp%\215830\" 2>nul
    move /Y "%myclosers%\CLIENT_CLOSERS*.zip" "%temp%\215830\" 2>nul
    move /Y "%myclosers%\CLOSERS.EXE" "%temp%\215830\" 2>nul
    move /Y "%myclosers%\LAUNCHER.exe" "%temp%\215830\" 2>nul
    move /Y "%myclosers%\MSVCR100.DLL" "%temp%\215830\" 2>nul
    move /Y "%myclosers%\PATCHER_CODE.LUA" "%temp%\215830\" 2>nul
    move /Y "%myclosers%\steam_appid.txt" "%temp%\215830\" 2>nul
    move /Y "%myclosers%\VER_CLOSERS.DLL" "%temp%\215830\" 2>nul
)

echo Limpiando logs...
rd /s /q "%SteamPath%\steamapps\common\Closers\Log" 2>nul
rd /s /q "%myclosers%\Log" 2>nul
rmdir "%SteamPath%\steamapps\common\Closers" 2>nul
rmdir "%myclosers%" 2>nul

echo Configurando enlaces simbolicos...
if exist "%myclosers%\LAUNCHER.exe" (
    if not exist "%SteamPath%\steamapps\common\Closers" (
        mklink /d "%SteamPath%\steamapps\common\Closers" "%myclosers%" >nul 2>&1
    )
) else if exist "%SteamPath%\steamapps\common\Closers\LAUNCHER.exe" (
    if not exist "%myclosers%" (
        mklink /d "%myclosers%" "%SteamPath%\steamapps\common\Closers" >nul 2>&1
    )
) else (
    echo Restaurando copias de seguridad...
    mkdir "%SteamPath%\steamapps\common\Closers" 2>nul
    mkdir "%myclosers%" 2>nul
    move /Y "%SteamPath%\steamapps\temp\215830\BUGTRAPU-X64.DLL" "%SteamPath%\steamapps\common\Closers\" 2>nul
    move /Y "%SteamPath%\steamapps\temp\215830\CLIENT_CLOSERS*.zip" "%SteamPath%\steamapps\common\Closers\" 2>nul
    move /Y "%SteamPath%\steamapps\temp\215830\CLOSERS.EXE" "%SteamPath%\steamapps\common\Closers\" 2>nul
    move /Y "%SteamPath%\steamapps\temp\215830\LAUNCHER.exe" "%SteamPath%\steamapps\common\Closers\" 2>nul
    move /Y "%SteamPath%\steamapps\temp\215830\MSVCR100.DLL" "%SteamPath%\steamapps\common\Closers\" 2>nul
    move /Y "%SteamPath%\steamapps\temp\215830\PATCHER_CODE.LUA" "%SteamPath%\steamapps\common\Closers\" 2>nul
    move /Y "%SteamPath%\steamapps\temp\215830\steam_appid.txt" "%SteamPath%\steamapps\common\Closers\" 2>nul
    move /Y "%SteamPath%\steamapps\temp\215830\VER_CLOSERS.DLL" "%SteamPath%\steamapps\common\Closers\" 2>nul
    move /Y "%temp%\215830\BUGTRAPU-X64.DLL" "%myclosers%\" 2>nul
    move /Y "%temp%\215830\CLIENT_CLOSERS*.zip" "%myclosers%\" 2>nul
    move /Y "%temp%\215830\CLOSERS.EXE" "%myclosers%\" 2>nul
    move /Y "%temp%\215830\LAUNCHER.exe" "%myclosers%\" 2>nul
    move /Y "%temp%\215830\MSVCR100.DLL" "%myclosers%\" 2>nul
    move /Y "%temp%\215830\PATCHER_CODE.LUA" "%myclosers%\" 2>nul
    move /Y "%temp%\215830\steam_appid.txt" "%myclosers%\" 2>nul
    move /Y "%temp%\215830\VER_CLOSERS.DLL" "%myclosers%\" 2>nul
    rmdir "%SteamPath%\steamapps\common\Closers" 2>nul
    rmdir "%myclosers%" 2>nul
    goto Fin3
)

echo Limpiando copias de seguridad...
for %%f in (BUGTRAPU-X64.DLL CLIENT_CLOSERS*.zip CLOSERS.EXE LAUNCHER.exe MSVCR100.DLL PATCHER_CODE.LUA steam_appid.txt VER_CLOSERS.DLL) do (
    del /s /q "%SteamPath%\steamapps\temp\215830\%%f" >nul 2>&1
    del /s /q "%temp%\215830\%%f" >nul 2>&1
)

if not exist "%SteamPath%\steam.exe" goto Fin4
goto Instalar1

:VerificarClosers
if exist "%myclosers%\LAUNCHER.exe" goto VerificarClosers1
goto Fin2

:VerificarClosers1
cls
echo ----------------------------------------------------------------------------
echo Deseas que Closers abra desde el navegador con esta carpeta?
echo %myclosers%
echo [1] Si   [2] No
echo ----------------------------------------------------------------------------
set "choice=0"
set /p choice=Respuesta: 
if /i "%choice%"=="1" goto Fin1
if /i "%choice%"=="2" goto Fin
cls
echo ----------------------------------------------------------------------------
echo Opcion invalida. Intenta de nuevo.
echo ----------------------------------------------------------------------------
timeout /t 2 >nul
goto VerificarClosers1

:Instalar1
echo Configurando Steam...
if not exist "%SteamPath%\steamapps\appmanifest_215830.acf" (
    echo "AppState" > "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo { >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     "appid" "215830" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     "Universe" "1" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     "LauncherPath" "%SteamPath%\steam.exe" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     "name" "Closers" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     "StateFlags" "4" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     "installdir" "closers" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     "LastUpdated" "1614450500" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     "SizeOnDisk" "4028576" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     "StagingSize" "0" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     "buildid" "5770229" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     "UpdateResult" "0" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     "BytesToDownload" "0" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     "BytesDownloaded" "0" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     "BytesToStage" "0" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     "BytesStaged" "0" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     "TargetBuildID" "0" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     "AutoUpdateBehavior" "0" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     "AllowOtherDownloadsWhileRunning" "2" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     "ScheduledAutoUpdate" "0" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     "InstalledDepots" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     { >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo         "215831" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo         { >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo             "manifest" "2539051219663136384" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo             "size" "4028576" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo         } >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     } >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     "SharedDepots" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     { >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo         "228983" "228980" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo         "228990" "228980" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     } >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     "UserConfig" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     { >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo         "language" "english" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     } >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     "MountedConfig" >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     { >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo     } >> "%SteamPath%\steamapps\appmanifest_215830.acf"
    echo } >> "%SteamPath%\steamapps\appmanifest_215830.acf"
)

:Instalar2
if exist "%myclosers%\LAUNCHER.exe" if exist "%SteamPath%\steamapps\common\Closers\LAUNCHER.exe" (
    call :Menu2
    goto Fin1
) else (
    if exist "%myclosers%\LAUNCHER.exe" set "ClosersPath=%myclosers%"
    if exist "%SteamPath%\steamapps\common\Closers\LAUNCHER.exe" set "ClosersPath=%SteamPath%\steamapps\common\Closers"
    goto Fin1
)

:Fin1
if not exist "%ClosersPath%" set "ClosersPath=%myclosers%"
echo Configurando protocolo para navegador...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\naddiclauncherna" /ve /d "URL:naddiclauncherna Protocol" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\naddiclauncherna" /v "URL Protocol" /d "" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\naddiclauncherna\DefaultIcon" /ve /d "\"%ClosersPath%\LAUNCHER.exe,1\"" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\naddiclauncherna\shell" /ve /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\naddiclauncherna\shell\open" /ve /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\naddiclauncherna\shell\open\command" /ve /d "\"%ClosersPath%\LAUNCHER.exe\" \"_NA\" \"%%1\"" /f >nul 2>&1

:Fin3
if not exist "%myclosers%" if not exist "%SteamPath%\steamapps\common\Closers" goto Fin2
set "isMyclosersEmpty=true"
set "isSteamPathEmpty=true"
if exist "%myclosers%\CW.exe" set "isMyclosersEmpty=false"
if exist "%SteamPath%\steamapps\common\Closers\CW.exe" set "isSteamPathEmpty=false"
if "%isMyclosersEmpty%"=="true" (
    if exist "%myclosers%" (
        cls
        echo ----------------------------------------------------------------------------
        echo Error detectado:
        echo La carpeta "%myclosers%" esta vacia o incompleta.
        echo Revisa si contiene una instalacion valida de Closers.
        echo Si no la usas, borrala o haz una copia de seguridad.
        echo Luego, ejecuta este script de nuevo.
        echo ----------------------------------------------------------------------------
        echo Presiona una tecla para salir...
        pause >nul
        exit
    )
)
if "%isSteamPathEmpty%"=="true" (
    cls
    echo ----------------------------------------------------------------------------
    echo Error detectado:
    echo La carpeta "%SteamPath%\steamapps\common\Closers" esta vacia o incompleta.
    echo Revisa si contiene una instalacion valida de Closers.
    echo Si no la usas, borrala o haz una copia de seguridad.
    echo Luego, ejecuta este script de nuevo.
    echo ----------------------------------------------------------------------------
    echo Presiona una tecla para salir...
    pause >nul
    exit
)

cls
echo ----------------------------------------------------------------------------
echo Operaciones completadas con exito.
echo Closers esta configurado para Navegador y Steam.
echo ----------------------------------------------------------------------------
echo Presiona una tecla para salir...
pause >nul
exit

:Fin2
cls
echo ----------------------------------------------------------------------------
echo Error detectado:
echo No se encontro ninguna instalacion de Closers.
echo Copia este script a la carpeta de Closers y ejecutalo de nuevo.
echo ----------------------------------------------------------------------------
echo Presiona una tecla para salir...
pause >nul
exit

:Fin4
cls
echo ----------------------------------------------------------------------------
echo Error detectado:
echo Steam no esta instalado o la ruta es invalida.
echo Instala Steam y ejecuta este script de nuevo.
echo ----------------------------------------------------------------------------
echo Presiona una tecla para salir...
pause >nul
exit

:Fin
cls
echo ----------------------------------------------------------------------------
echo Instalacion cancelada.
echo ----------------------------------------------------------------------------
echo Presiona una tecla para salir...
pause >nul
exit

:Menu2
cls
echo ----------------------------------------------------------------------------
echo Hay dos rutas de instalacion de Closers. Elige una:
echo [1] %myclosers%
echo [2] %SteamPath%\steamapps\common\Closers
echo ----------------------------------------------------------------------------
set "var=0"
set /p var=Respuesta (1 o 2): 
if /i "%var%"=="1" set "ClosersPath=%myclosers%" & goto :eof
if /i "%var%"=="2" set "ClosersPath=%SteamPath%\steamapps\common\Closers" & goto :eof
cls
echo ----------------------------------------------------------------------------
echo Opcion invalida. Intenta de nuevo.
echo ----------------------------------------------------------------------------
timeout /t 2 >nul
goto Menu2
