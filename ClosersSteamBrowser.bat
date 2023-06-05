@echo off
title Closers desde el Navegador y Steam By Henry
mode con: cols=76 lines=20
color 0a

:: Elevando el batch como administador.
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Solicitando permisos de administador...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

:: Confirmar que se va a habilitar el uso de Steam

:Menu1
CLS
SET "choice=A"
echo Este script va a habilitar el uso de Steam tanto por el navegador.
set /p choice="Seguro que deseas continuar? (S/N): "
if /i "%choice%"=="S" goto instalar
if /i "%choice%"=="N" goto fin
CLS
echo Opcion invalida.
TIMEOUT /T 2 >NUL
goto Menu1

:instalar
set "myclosers=C:\Closers"
:: Leer el valor de la entrada del registro y asignarlo a la variable myclosers1
for /f "tokens=2*" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\naddiclauncherna\shell\open\command" /v ""') do set "myclosers1=%%~b"
:: Quitar las comillas dobles de la variable myclosers1
set "myclosers1=%myclosers1:"=%"
:: Quitar el nombre del archivo y los parámetros de la variable myclosers1
set "myclosers1=%myclosers1:\LAUNCHER.exe _NA =%"
set "myclosers1=%myclosers1:~0,-2%"

:: Cambiar la variable en caso que este en el registro de windows
if exist "%myclosers1%" set "myclosers=%myclosers1%"

:: Verificar que el Launcher de Closers este en la misma carpeta que Closers
If exist "%~dp0LAUNCHER.exe" set "myclosers=%~dp0"

:: Obtener la ruta de instalacion de Steam del registro
for /f "tokens=2*" %%a in ('reg query "HKEY_CURRENT_USER\Software\Valve\Steam" /v SteamPath') do set "SteamPath=%%~b"
set "SteamPath=%SteamPath:/=\%"

:: Comprobando Si la instalacion de Steam esta incompleta y haciendo copia de seguridad
IF NOT Exist "%SteamPath%\steamapps\common\Closers\Cw.exe" IF NOT Exist "%SteamPath%\steamapps\common\Closers\DAT" (
MKDIR "%SteamPath%\steamapps\temp\215830"
Move /Y "%SteamPath%\steamapps\common\Closers\LAUNCHER.exe" "%SteamPath%\steamapps\temp\215830\"
Move /Y "%SteamPath%\steamapps\common\Closers\BUGTRAPU-X64.DLL" "%SteamPath%\steamapps\temp\215830\"
)

::Remover Carpeta de Closers solo si esta vacia.
set "folder=%SteamPath%\steamapps\common\Closers"
Call :CarpetaVacia
set "folder=%myclosers%"
Call :CarpetaVacia
Goto SalirVacio
:CarpetaVacia
cd /d "%folder%"
for /f "tokens=1" %%$ in ('dir /b ^| find /v /c ""') do (
set "valor=%%$"
)
if %valor% equ 0 (
CLS
echo La carpeta esta vacia, se borrara, continuando con la instalacion...
cd ..
rmdir "%folder%"
) else (
CLS
echo La carpeta no esta vacia, no se borrara, continuando con la instalacion...
)
exit /b 0
GOTO:EOF
:SalirVacio

:: Comprobar si Closers esta instalado en C:\Closers o en la carpeta de Steam y crear un enlace simbolico si no existe
if exist "%myclosers%\LAUNCHER.exe" (
    if not exist "%SteamPath%\steamapps\common\Closers" (
        mklink /d "%SteamPath%\steamapps\common\Closers" "%myclosers%"
    )
) else if exist "%SteamPath%\steamapps\common\Closers\LAUNCHER.exe" (
    if not exist "%myclosers%" (
        mklink /d "%myclosers%" "%SteamPath%\steamapps\common\Closers"
    )
) else (
	goto Fin3
)

:: Removiendo Copias de Seguridad Si la carpeta de destino ya contiene Laucher y BUGTRAPU-X64
IF Exist "%SteamPath%\steamapps\temp\215830\LAUNCHER.exe" IF NOT EXIST "%SteamPath%\steamapps\common\Closers\LAUNCHER.exe"  (
Move /Y "%SteamPath%\steamapps\temp\215830\LAUNCHER.exe" "%SteamPath%\steamapps\common\Closers\"
Move /Y "%SteamPath%\steamapps\temp\215830\BUGTRAPU-X64.DLL" "%SteamPath%\steamapps\common\Closers\"
)
DEL /S /Q "%SteamPath%\steamapps\temp\215830\LAUNCHER.exe"
DEL /S /Q "%SteamPath%\steamapps\temp\215830\BUGTRAPU-X64.DLL"

:: Comprobando si esta instalado Steam
if exist "%SteamPath%\steam.exe" goto Instalar1
goto VerificarClosers

:VerificarClosers
if exist "%myclosers%\LAUNCHER.exe" goto VerificarClosers1
goto Fin2

:VerificarClosers1
SET "choice=0"
CLS
echo Deseas que Closers abra por el Navegador con la siguiente carpeta?
set /p choice="%myclosers% (1 para Si, 2 para No): "
if /i "%choice%"=="1" goto Fin1
if /i "%choice%"=="2" goto Fin
CLS
echo Opcion invalida.
TIMEOUT /T 2 >NUL	
goto VerificarClosers

:Instalar1
:: Comprobar si existe el archivo appmanifest_215830.acf y crearlo si no existe
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

:: Comprobar si %myclosers% es igual a %SteamPath%\steamapps\common\Closers y si existe el archivo "C:\Closers\LAUNCHER.exe"
if "%myclosers%"=="%SteamPath%\steamapps\common\Closers" (
  if exist "C:\Closers\LAUNCHER.exe" (
    set "myclosers=C:\Closers"
  )
)

:: Comprobar si hay dos rutas de instalacion de Closers y preguntar al usuario con cual quiere trabajar
:Instalar2
if exist /f "%myclosers%\LAUNCHER.exe" /f if exist /f "%SteamPath%\steamapps\common\Closers\LAUNCHER.exe" /f (
    CLS
	SET "var=0"
	echo Hay dos rutas de instalacion de Closers. Con cual carpeta de instalacion le gustaria trabajar?
    echo 1) %myclosers%
    echo 2) %SteamPath%\steamapps\common\Closers
	echo.
	SET /P var= ^> Elige una Opcion y presiona ENTER: 
	IF /I "%var%"=="1" set "ClosersPath=%myclosers%" & GOTO Fin1
	IF /I "%var%"=="2" set "ClosersPath=%SteamPath%\steamapps\common\Closers" & GOTO Fin1
	CLS
	echo Opcion invalida.
	TIMEOUT /T 2 >NUL	
	goto Instalar2
) else (
    :: Usar la única ruta de instalacion encontrada
    if exist "%myclosers%\LAUNCHER.exe" set "ClosersPath=%myclosers%"
    if exist "%SteamPath%\steamapps\common\Closers\LAUNCHER.exe" set "ClosersPath=%SteamPath%\steamapps\common\Closers"
)

:Fin1
IF not exist "%ClosersPath%" set "ClosersPath=%myclosers%"
:: Añadir el registro de Windows para el protocolo naddiclauncherna
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\naddiclauncherna" /ve /d "\"URL:naddiclauncherna Protocol\"" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\naddiclauncherna" /v "URL Protocol" /d "" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\naddiclauncherna\DefaultIcon" /ve /d "\"%ClosersPath%\LAUNCHER.exe,1\"" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\naddiclauncherna\shell" /ve /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\naddiclauncherna\shell\open" /ve /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\naddiclauncherna\shell\open\command" /ve /d "\"%ClosersPath%\LAUNCHER.exe\" \"_NA\" \"%%1\"" /f

:Fin3
:: Comprobar si alguna de las carpetas está vacía
IF NOT EXIST "%myclosers%" IF NOT EXIST "%SteamPath%\steamapps\common\Closers" Goto Fin2
set "isMyclosersEmpty=true"
set "isSteamPathEmpty=true"
if exist "%myclosers%\CW.exe" set "isMyclosersEmpty=false"
if exist "%SteamPath%\steamapps\common\Closers\CW.exe" set "isSteamPathEmpty=false"
if "%isMyclosersEmpty%"=="true" (
	IF NOT EXIST "%myclosers%" Goto Fin4
	CLS
	Echo [] Se han encontrado el siguiente error:
    Echo - La carpeta ["%myclosers%"] contiene una instalacion residual o incompleta de Closers, revisa si dicha carpeta contiene una instalacion valida de closers, si no esta utilizando esa carpeta puedes borrarla o hacer copia de seguridad en caso de no estar seguro.
	Echo - Luego de resolver ese inconveniente, vuelveme a ejecutar para que la version de Steam y Navegador funcionen al mismo tiempo.
	Echo - Presione alguna tecla para salir del Programa...
PAUSE>NUL
Exit
)
:Fin4
if "%isSteamPathEmpty%"=="true" (
	CLS
	Echo [] Se han encontrado el siguiente error:
    Echo - La carpeta ["%SteamPath%\steamapps\common\Closers"] contiene una instalacion residual o incompleta de Closers, revisa si dicha carpeta contiene una instalacion valida de closers, si no esta utilizando esa carpeta puedes borrarla o hacer copia de seguridad en caso de no estar seguro.
	Echo - Luego de resolver ese inconveniente, vuelveme a ejecutar para que la version de Steam y Navegador funcionen al mismo tiempo.
	Echo - Presione alguna tecla para salir del Programa...
PAUSE>NUL
Exit
)

CLS
Echo - Se han ejecutado todas las operaciones correctamente.
Echo - Presione alguna tecla para salir del Programa...
PAUSE>NUL
exit

:Fin2
CLS
Echo [] Se han encontrado el siguiente error:
Echo - No detecte ninguna instalacion de Closers, copiame en la carpeta
Echo donde tengas instalado Closers y luego ejecutame de nuevo.
Echo - Presione alguna tecla para salir del Programa...
PAUSE>NUL
Exit

:Fin
CLS
echo - Se ha cancelado la instalacion.
Echo - Presione alguna tecla para salir del Programa...
PAUSE>NUL
exit

