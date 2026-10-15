# Meegeleverde hulpmiddelen in release 2.3

De onderstaande programma's worden ongewijzigd als zelfstandige hulpmiddelen meegeleverd. Hun eigen licenties blijven van toepassing. De exacte programmaversies en SHA-256-controles staan in het releasepakket.

| Bestand | Versie in release 2.3 | Herkomst en broncode | Licentiegegevens |
| --- | --- | --- | --- |
| deno.exe | 2.9.7, Windows x64 | [Officiële release](https://github.com/denoland/deno/releases/tag/v2.9.7), [broncode](https://github.com/denoland/deno/tree/v2.9.7) | MIT; `licenses/deno-LICENSE.md`. De upstream broncode bevat ook de gegevens van afhankelijkheden. |
| yt-dlp.exe | 2026.08.19 | [Officiële release en broncode](https://github.com/yt-dlp/yt-dlp/releases/tag/2026.08.19) | De kern is Unlicense; de gebundelde executable bevat ook afhankelijkheden met eigen licenties. Zie `licenses/yt-dlp-LICENSE.txt` en `licenses/yt-dlp-THIRD_PARTY_LICENSES.txt`. |
| ffmpeg.exe / ffprobe.exe | N-122224-gc50e5c7778-20251222 | Bestaande Windows x64-build uit de tools-map; [FFmpeg-bronrevisie](https://github.com/FFmpeg/FFmpeg/tree/c50e5c7778) | Deze build meldt GPL versie 3 of later; zie `licenses/FFmpeg-COPYING.GPLv3.txt`. Buildconfiguratie en versiegegevens staan in `licenses/FFmpeg-build.txt`. Externe codec-bibliotheken hebben daarnaast eigen licenties. |

Uitleg over [yt-dlp en JavaScript-runtimes](https://github.com/yt-dlp/yt-dlp/wiki/EJS).

De updatefunctie vervangt uitsluitend yt-dlp.exe. Versiegegevens en controles in het oorspronkelijke pakket beschrijven de bestanden op het moment van uitgifte.
