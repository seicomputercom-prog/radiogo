# Piano Sviluppo - RadioGo by infobit.cloud

## Panoramica

**Nome App:** RadioGo  
**Sottotitolo:** by infobit.cloud  
**Tipo:** App streaming radio Android (Flutter)  
**Versione:** 1.0.0  
**Repo:** seicomputercom-prog/radiogo

---

## Tecnologie

| Componente | Tecnologia |
|-----------|------------|
| Framework | Flutter 3.44.x / Dart 3.12.x |
| State Management | GetX |
| Local Storage | Hive |
| Audio Playback | just_audio + audio_service |
| API Stazioni | Radio-Browser.info |
| CI/CD | GitHub Actions (workflow_dispatch) |
| Push | Git Data API (no SSH) |

---

## Tema: Cyberpunk / Matrix Green Terminal

- Sfondo: #0A0A0A (nero profondo)
- Superficie: #0D1117
- Accento primario: #00FF41 (verde Matrix)
- Accento secondario: #39FF14 (neon verde)
- Card: #161B22
- Font titoli: Orbitron (Bold)
- Font corpo: ShareTechMono
- Effetti: glow/neon su elementi interattivi, scanline overlay opzionale
- Titolo app: "RadioGO" grande in Orbitron verde + "by infobit.cloud" piu' piccolo sotto

---

## Struttura Progetto

```
radiogo/
+-- .github/workflows/build-apk.yml
+-- android/ (boilerplate completo)
+-- assets/images/ (logo, icon)
+-- lib/
|   +-- main.dart
|   +-- app.dart
|   +-- bindings/ (initial, player)
|   +-- controllers/ (player, stations, search, settings, main)
|   +-- models/ (radio_station)
|   +-- services/ (radio_browser, audio_player, audio_handler, storage)
|   +-- routes/ (app_routes)
|   +-- views/ (splash, home, stations, search, favorites, settings, player)
|   +-- widgets/ (marquee, station_card, mini_player, cyberpunk_widgets)
|   +-- l10n/ (app_translations IT+EN)
|   +-- theme/ (app_theme, app_colors)
|   +-- utils/ (constants)
+-- pubspec.yaml
+-- README.md
```

---

## Feature Principali

1. **Streaming Radio** - Riproduzione HTTP/AAC/MP3 con just_audio
2. **Catalogo Stazioni** - Radio-Browser.info (~50k stazioni, auto-aggiornamento link)
3. **Radio Arcobaleno** - Prima stazione predefinita
4. **Stazioni Italiane** - Filtro per paese Italia
5. **Stazioni Internazionali** - Tutte le nazioni
6. **Ricerca** - Real-time con debounce
7. **Preferiti** - Salvati in Hive (offline)
8. **Recenti** - Ultime 20 stazioni ascoltate
9. **Background Playback** - audio_service + notifica lockscreen
10. **ICY Metadata** - Titolo traccia in tempo reale
11. **Marquee** - Scorrimento testo stazione e traccia
12. **Tema Cyberpunk** - Verde Matrix/terminale
13. **Bilingue IT+EN** - Tutte le stringhe tradotte
14. **Cache Offline** - Risposte API in cache 24h (Hive)
15. **Pull to Refresh** - Aggiornamento manuale lista

---

## Piano di Sviluppo (completato)

### Fase 1 - Struttura e configurazione
- [x] Creazione repository GitHub
- [x] Struttura directory progetto
- [x] pubspec.yaml con dipendenze
- [x] Android boilerplate (Manifest, Gradle, MainActivity)

### Fase 2 - Core services
- [x] RadioStation model
- [x] RadioBrowserService (API)
- [x] AudioPlayerService + AudioHandler (background)
- [x] StorageService (Hive favorites/recent/cache)

### Fase 3 - Controllers & Bindings
- [x] PlayerController
- [x] StationsController
- [x] SearchController
- [x] SettingsController
- [x] MainController
- [x] InitialBinding + PlayerBinding

### Fase 4 - UI/Views
- [x] SplashScreen con Matrix rain
- [x] HomeScreen con bottom nav + mini player
- [x] StationsScreen con filtri
- [x] SearchScreen con debounce
- [x] FavoritesScreen con swipe-to-remove
- [x] SettingsScreen (lingua, cache)
- [x] PlayerScreen (full screen)
- [x] Marquee widget
- [x] StationCard widget
- [x] MiniPlayer widget
- [x] Cyberpunk widgets (glow, neon, scanline)

### Fase 5 - Tema & Localizzazione
- [x] AppTheme cyberpunk verde
- [x] AppColors palette Matrix
- [x] Traduzioni IT+EN complete

### Fase 6 - Push & Build
- [ ] Push iniziale via Git Data API
- [ ] Workflow GitHub Actions
- [ ] Build APK
- [ ] Download APK
- [ ] ZIP delivery + Dual Kit
