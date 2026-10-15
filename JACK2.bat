@echo off
setlocal EnableExtensions

REM Test if we can access the script directory
if not exist "%~dp0" (
    echo [FOUT] Kan script directory niet vinden
    pause
    exit /b 1
)

REM Try to change directory with error checking
cd /d "%~dp0" 2>nul
if errorlevel 1 (
    echo [FOUT] Kan niet naar script directory navigeren: %~dp0
    pause
    exit /b 1
)

set "TOOLS=%~dp0tools"
set "BROWSER=chrome"

REM Verify we're in the right place
echo Huidige directory: %CD%
echo Tools pad: %TOOLS%
pause

:START
cls
echo  === JACK THE RIPPER v2.3 ==============================================
echo  Kies output, plak playlist URL, en gaan.
echo  =======================================================================
echo.

REM --- Dependency check: yt-dlp altijd nodig ---
if not exist "%TOOLS%\yt-dlp.exe" (
  echo [FOUT] yt-dlp.exe niet gevonden in:
  echo %TOOLS%
  pause
  goto START
)

echo  [1] MP3 (audio extract)
echo  [2] MP4 (video)
echo  [U] Update yt-dlp.exe (standalone)
echo  [Q] Quit
echo.
set "CHOICE="
set /p CHOICE="Keuze (1/2/U/Q): "

if /I "%CHOICE%"=="1" goto MODE_MP3
if /I "%CHOICE%"=="2" goto MODE_MP4
if /I "%CHOICE%"=="U" goto UPDATE_YTDLP
if /I "%CHOICE%"=="Q" goto END

echo.
echo [FOUT] Ongeldige keuze.
pause >nul
goto START

:UPDATE_YTDLP
call :DO_UPDATE_YTDLP
echo.
pause
goto START

:MODE_MP3
REM ffmpeg (+ liefst ffprobe) nodig voor MP3 extract
if not exist "%TOOLS%\ffmpeg.exe" (
  echo [FOUT] ffmpeg.exe niet gevonden in:
  echo %TOOLS%
  pause
  goto START
)
if not exist "%TOOLS%\ffprobe.exe" (
  echo [LET OP] ffprobe.exe ontbreekt in %TOOLS%
  echo         Dit kan soms problemen geven. Zet ffprobe.exe naast ffmpeg.exe.
  echo.
  pause
)
set "MODE=MP3"
goto ASK_URL

:MODE_MP4
REM ffmpeg nodig voor video+audio merge naar mp4
if not exist "%TOOLS%\ffmpeg.exe" (
  echo [FOUT] ffmpeg.exe niet gevonden in:
  echo %TOOLS%
  pause
  goto START
)
if not exist "%TOOLS%\ffprobe.exe" (
  echo [LET OP] ffprobe.exe ontbreekt in %TOOLS%
  echo         Dit kan soms problemen geven. Zet ffprobe.exe naast ffmpeg.exe.
  echo.
  pause
)
set "MODE=MP4"
goto ASK_URL

:ASK_URL
REM Gebruik uitsluitend de meegeleverde JavaScript-runtime.
if not exist "%TOOLS%\deno.exe" (
  echo [FOUT] deno.exe ontbreekt in de tools-map.
  echo Kopieer de volledige Jack The Ripper-map, inclusief tools.
  pause
  goto START
)
"%TOOLS%\deno.exe" --version >nul 2>&1
if errorlevel 1 (
  echo [FOUT] De meegeleverde deno.exe kan niet starten.
  echo Deze versie is bedoeld voor 64-bits Windows.
  pause
  goto START
)
echo.
set "PL="
set /p PL="Playlist URL: "

if "%PL%"=="" (
  echo.
  echo [FOUT] Geen URL ingevuld.
  pause >nul
  goto START
)

if /I "%MODE%"=="MP3" goto RUN_MP3
if /I "%MODE%"=="MP4" goto RUN_MP4

echo.
echo [FOUT] Interne fout: MODE niet gezet.
pause >nul
goto START

:RUN_MP3
"%TOOLS%\yt-dlp.exe" --no-js-runtimes --js-runtimes "deno:%TOOLS%\deno.exe" --ffmpeg-location "%TOOLS%" ^
  -f "ba/b" ^
  -x --audio-format mp3 --audio-quality 0 ^
  -o "%%(playlist_title)s\%%(playlist_index)02d - %%(title)s.%%(ext)s" ^
  --ignore-errors --no-abort-on-error --newline ^
  "%PL%"
goto DONE

:RUN_MP4
"%TOOLS%\yt-dlp.exe" --no-js-runtimes --js-runtimes "deno:%TOOLS%\deno.exe" --ffmpeg-location "%TOOLS%" ^
  -f "bv*+ba/b/18" --merge-output-format mp4 ^
  -o "%%(playlist_title)s\%%(playlist_index)02d - %%(title)s.%%(ext)s" ^
  --ignore-errors --no-abort-on-error --newline ^
  "%PL%"
goto DONE

:DONE
echo.
echo  === JACK THE RIPPER ============================================
echo  Klaar! Kijk in de aangemaakte playlist-map :)
echo  ================================================================
echo.
echo Druk op een toets om terug te gaan naar het menu...
pause >nul
goto START

:END
exit /b


REM ==================================================================
REM  FUNCTIONS
REM ==================================================================
:DO_UPDATE_YTDLP
setlocal
set "YTDLP=%TOOLS%\yt-dlp.exe"
set "URL=https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"
set "NEW=%TOOLS%\yt-dlp.new.exe"
set "OLD=%TOOLS%\yt-dlp.old.exe"

echo.
echo  [yt-dlp] Huidige versie:
"%YTDLP%" --version
echo.

choice /c YN /m "Updaten naar nieuwste standalone yt-dlp.exe?"
if errorlevel 2 goto UPD_CANCEL

echo Downloaden naar tools-map...
if exist "%NEW%" del /q "%NEW%" >nul 2>&1

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference='Stop';" ^
  "Invoke-WebRequest -Uri '%URL%' -OutFile '%NEW%' -UseBasicParsing"
if errorlevel 1 goto UPD_DL_FAIL

if not exist "%NEW%" goto UPD_DL_FAIL

"%NEW%" --version >nul 2>&1
if errorlevel 1 goto UPD_INVALID

if exist "%OLD%" del /q "%OLD%" >nul 2>&1

move /y "%YTDLP%" "%OLD%" >nul 2>&1
if errorlevel 1 goto UPD_CANT_REPLACE

move /y "%NEW%" "%YTDLP%" >nul 2>&1
if errorlevel 1 goto UPD_RESTORE

echo.
echo [OK] Nieuwe versie:
"%YTDLP%" --version
endlocal & exit /b 0

:UPD_CANCEL
echo Update overgeslagen.
endlocal & exit /b 0

:UPD_DL_FAIL
echo [FOUT] Download mislukt (PowerShell/Defender/rechten).
echo Bestand %NEW% is niet bruikbaar of niet aangemaakt.
endlocal & exit /b 0

:UPD_INVALID
echo [FOUT] Download is geen geldige yt-dlp.exe (geblokkeerd/corrupt?).
del /q "%NEW%" >nul 2>&1
endlocal & exit /b 0

:UPD_CANT_REPLACE
echo [FOUT] Kan bestaande yt-dlp.exe niet hernoemen. Staat yt-dlp nog open?
del /q "%NEW%" >nul 2>&1
endlocal & exit /b 0

:UPD_RESTORE
echo [FOUT] Kon nieuwe yt-dlp.exe niet plaatsen. Backup wordt teruggezet.
move /y "%OLD%" "%YTDLP%" >nul 2>&1
del /q "%NEW%" >nul 2>&1
endlocal & exit /b 0

