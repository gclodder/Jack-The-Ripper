# Jack The Ripper 2.3

Download YouTube-video's en playlists als MP3 of MP4 op **64-bits Windows**, zonder aparte installatie van Node.js, Deno, Python of FFmpeg.

## Downloaden en starten

1. Open [release 2.3](https://github.com/gclodder/Jack-The-Ripper/releases/tag/v2.3).
2. Download **Jack-The-Ripper-2.3-Windows-x64.zip** onder Assets. De automatisch aangeboden **Source code**-archieven bevatten geen programma's en zijn niet het gebruiksklare pakket.
3. Pak de **hele ZIP** uit in een map waarin je bestanden mag opslaan. Start niet vanuit de ZIP.
4. Open `JACK2.bat`.
5. Kies **1** voor MP3 of **2** voor MP4.
6. Plak een YouTube-video- of playlistlink en druk op Enter.
7. Laat het venster open totdat het downloaden klaar is. Met Ctrl+C kun je stoppen.

Internettoegang is nodig. De computer moet het uitvoeren van de meegeleverde programma's toestaan; op een beheerde school- of werkcomputer kan dit door de beheerder beperkt zijn.

## Links en uitvoer

Een playlistlink bevat `list=`, bijvoorbeeld `https://www.youtube.com/playlist?list=...`.
Een korte link zoals `https://youtu.be/...` zonder `list=` verwijst naar één video.

De bestanden komen naast het script in een map met de naam van de playlist. Bij een losse video gebruikt deze versie de map `NA` en kan de bestandsnaam met `NA - ` beginnen.

## Wat zit in het pakket?

```text
Jack-The-Ripper-2.3/
  JACK2.bat
  README.md
  CHANGELOG.txt
  THIRD-PARTY.md
  SHA256SUMS.txt
  licenses/
  tools/
    yt-dlp.exe
    ffmpeg.exe
    ffprobe.exe
    deno.exe
    versions.json
    deno-source.json
```

**Deel of verplaats de volledige map, inclusief `tools` en `licenses`.** Het script gebruikt expliciet de meegeleverde `tools\deno.exe`. Een op de computer geïnstalleerde Node.js is niet nodig.

## Problemen en updates

- **`deno.exe` ontbreekt:** pak het volledige releasepakket opnieuw uit. Kopieer niet alleen het batchbestand.
- **Video bestaat, maar is volgens het programma niet beschikbaar:** controleer de link en kies **U** om yt-dlp bij te werken. Versie 2.3 verhelpt de fout die ontstond doordat er geen JavaScript-runtime werd gebruikt.
- **Andere YouTube-fout:** toegang kan afhangen van de video, aanmelding, regio of netwerk. Niet iedere video is downloadbaar.
- Optie **U** werkt alleen **yt-dlp** bij. FFmpeg en Deno worden daarmee niet bijgewerkt. Download een nieuw compleet releasepakket wanneer deze onderdelen een update nodig hebben.
- YouTube verandert regelmatig; blijvende werking kan niet worden gegarandeerd.

Gebruik downloads waarvoor je toestemming hebt.

## Voor ontwikkelaars

De repository bevat het script, documentatie, licenties en een verpakkingsscript. De grote uitvoerbare bestanden worden als release-download verspreid, niet in Git opgeslagen.

Met een volledige, geteste tools-map maak je hetzelfde pakket met Windows PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\Build-Release.ps1 -ToolsDirectory 'C:\pad\naar\tools' -OutputDirectory 'C:\pad\naar\output'
```

Het verpakkingsscript neemt uitsluitend de vier benodigde `.exe`-bestanden en de vermelde documentatie mee. Reservekopieën, eerdere executables, downloads en `.git` worden niet opgenomen. Bestandscontroles en programmaversies worden in het pakket vastgelegd.

Zie [THIRD-PARTY.md](THIRD-PARTY.md) voor de herkomst en licenties van de meegeleverde hulpmiddelen en de [yt-dlp-uitleg over JavaScript-runtimes](https://github.com/yt-dlp/yt-dlp/wiki/EJS).
