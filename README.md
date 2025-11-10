# The Melophiles
**Your All-in-One Offline Music Sanctuary**

> **"Music is the soundtrack of your life."** – *Dick Clark*  
> **The Melophiles** turns your device into a **personal jukebox** — **100% offline**, **ad-free**, **beautifully animated**, and **lightning fast**.

---

## Overview

| | |
|---|---|
| **App Name** | **The Melophiles** |
| **Tagline** | *Our Music App For All* |
| **Platform** | **Android • iOS** |
| **Architecture** | **Clean, Modular, Offline-First** |
| **State Management** | `GetX` (Reactive, Lightweight) |
| **Audio Engine** | `just_audio` + `just_audio_background` |
| **Metadata & Art** | `on_audio_query` (Embedded MP3 Art) |
| **Database** | `Hive` (Blazing Fast Local Storage) |
| **UI Framework** | **Material 3 + One UI Inspired** |
| **Fonts** | **Poppins (All Weights)** |
| **Icons** | **Icons8 + Animated Icons** |
| **Animations** | **Lottie + Animated Text + Marquee** |

---

## Features

| Feature | Description |
|--------|-----------|
| **Offline Playback** | No internet? No problem. Play your local music anywhere. |
| **Embedded Album Art** | Auto-extracts cover art from MP3 files — no external API. |
| **A-Z Auto-Sort** | Tracks auto-sorted alphabetically. First song plays on launch. |
| **Mini-Player** | Persistent, animated, with marquee titles & embedded art. |
| **Animated Tabs** | Smooth `AnimatedIcon` transitions on tab switch. |
| **Artist Grid View** | Elevated cards with **photo at bottom**, name, and song count. |
| **Smart Search** | Real-time filtering across Tracks, Albums, Artists. |
| **Haptic Feedback** | Light, satisfying taps — feels premium. |
| **Background Play** | Lock screen + notification controls. |
| **Android Auto Ready** | Works seamlessly in your car. |
| **Custom Splash & Icon** | Snoopy-themed branding with adaptive icons. |

---

## Tech Stack & Dependencies

### **UI & Design**
```yaml
cupertino_icons: ^1.0.8
google_fonts: ^6.3.2
lottie: ^1.3.0
animated_text_kit: ^4.3.0
marquee: ^2.3.0
iconsax: ^0.0.8
flutter_masonry_view: ^0.0.2
```

### **State & Navigation**
```yaml
get: ^4.7.2
```

### **Audio & Playback**
```yaml
just_audio: ^0.10.5
audio_service: ^0.18.12
just_audio_background: ^0.0.1-beta.12
on_audio_query: ^2.9.0
audio_session: 0.1.25
audio_wave: ^0.1.5
```

### **Storage & Persistence**
```yaml
hive: ^2.2.3
hive_flutter: ^1.1.0
path_provider: ^2.1.5
shared_preferences: ^2.5.3
```

### **System & Permissions**
```yaml
permission_handler: ^12.0.1
device_info_plus: ^12.2.0
connectivity_plus: ^7.0.0
url_launcher: ^6.3.2
intl: ^0.20.2
package_info_plus: ^9.0.0
image_picker: ^1.2.0
```

### **Branding & Launch**
```yaml
flutter_native_splash: ^2.4.4
flutter_launcher_icons: ^0.14.4
```

---

## Project Structure

```
lib/
├── controllers/        # GetX Controllers
├── features/
│   ├── library/        # Tracks (A-Z)
│   ├── albums/         # Grid + Tracks
│   ├── artists/        # Grid Cards (photo at bottom)
│   ├── genres/
│   ├── folders/
│   ├── playlists/
│   └── favorites/
├── models/             # Song, Playlist models
├── services/           # Audio, Metadata, Permissions
├── widgets/            # Reusable: MiniPlayer, Marquee, etc.
└── main.dart
```

---

## Getting Started

### 1. **Clone & Install**
```bash
git clone https://github.com/yourusername/the_melophiles.git
cd the_melophiles
flutter pub get
```

### 2. **Generate Icons & Splash**
```bash
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash:create
```

### 3. **Run**
```bash
flutter run
```

> **First launch**: Grant storage permission → auto-scan begins.

---

## Permissions (Auto-Handled)

| Permission | Purpose |
|----------|--------|
| `READ_EXTERNAL_STORAGE` | Scan music files |
| `POST_NOTIFICATIONS` | Background playback |
| `FOREGROUND_SERVICE` | Audio service |

---

## Fonts: Poppins (All 14 Weights)

```yaml
Poppins-Thin (100) → Poppins-ExtraBold (800)
+ Italic variants
```

Used for:
- App Bar titles
- Marquee text
- Card labels
- Mini-player

---

## Assets

```
assets/
├── images/             # App icon, placeholders
└── animations/         # Lottie JSON files
```

---

## Screenshots (Coming Soon)

| Home | Artists | Now Playing |
|------|---------|-------------|
| ![Home] | ![Artists] | ![Player] |

*(Add real screenshots here later)*

---

## Contributing

We **welcome contributions**!
1. Fork the repo
2. Create your feature branch
3. Commit your changes
4. Open a Pull Request

---

## Roadmap

| Feature | Status |
|-------|--------|
| Sleep Timer | Planned |
| Equalizer | Planned |
| Lyrics (Embedded) | Planned |
| Widgets (4x1, 4x2) | Planned |
| Dark Mode Toggle | Done |
| Crossfade | Planned |
| Tag Editor | Planned |

---

## Built With Love

**Flutter** • **Dart** • **Hive** • **just_audio**  
**Made in India**

> **"Where words fail, music speaks."** – *Hans Christian Andersen*

---

## Support

For issues, suggestions, or just to say hi:  
[Open an Issue](https://github.com/yourusername/the_melophiles/issues)

---

**The Melophiles** — *Because your music deserves a beautiful home.*

---

*Last Updated: November 10, 2025*  
*Made with [Flutter](https://flutter.dev) • [GetX](https://pub.dev/packages/get) • [Hive](https://pub.dev/packages/hive)*

---

**Star this repo if you love music!**