# NeonCalc ✦ Flutter Calculator App

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter" />
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart" />
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Platform-iOS%20%7C%20Android-lightgrey?style=for-the-badge" />
</p>

A **premium, production-ready calculator app** built with Flutter. Features a stunning dark/light theme with neon accents, smooth animations, calculation history, and clean architecture using the Provider pattern.

---

## ✨ Features

### Core
- ➕ Basic operations — add, subtract, multiply, divide
- 🔬 Advanced operations — square root (`√`), exponent (`^`), percentage (`%`), parentheses
- ⌨️ Real-time live result preview as you type
- 🔄 Toggle sign (`±`) and backspace (`⌫`)
- 🧹 Clear current entry (`C`) and All Clear (`AC`)
- 🔢 Full decimal support
- ⚠️ Edge case handling — division by zero, unbalanced parens, invalid expressions

### UI/UX
- 🌙 **Dark / Light mode toggle** — persisted across sessions
- 🌈 **Neon accent color system** — cyan, violet, green per button type
- 🪄 **Press animations** — scale + glow on every button tap
- 📊 **Display panel** — large main display + small live result line
- 📜 **Calculation history drawer** — tap any result to restore it
- 📱 **Responsive layout** — scales gracefully across screen sizes

### Technical
- 🏗️ Clean architecture — logic, providers, widgets fully separated
- 🔌 Provider-based state management (`ChangeNotifier`)
- 💾 SharedPreferences persistence — theme + history survive restarts
- 🖋️ JetBrains Mono monospace display font for that authentic calc feel

---

## 📸 Screenshots

| Dark Mode | Light Mode | History |
|-----------|------------|---------|
| ![dark](https://via.placeholder.com/200x400/0A0E1A/00E5FF?text=Dark+Mode) | ![light](https://via.placeholder.com/200x400/F0F4FF/4B00D4?text=Light+Mode) | ![history](https://via.placeholder.com/200x400/111827/B040FF?text=History) |

> 📸 Replace placeholder images with actual screenshots after running the app.

---

## 🚀 Getting Started

### Prerequisites

| Tool | Version |
|------|---------|
| Flutter SDK | ≥ 3.0.0 |
| Dart SDK | ≥ 3.0.0 |
| Android Studio / Xcode | Latest stable |

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/YOUR_USERNAME/flutter_calculator.git
cd flutter_calculator

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

### Build for Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## 📁 Project Structure

```
flutter_calculator/
├── lib/
│   ├── main.dart                   # App entry point, Provider setup
│   ├── models/
│   │   ├── calculator_logic.dart   # Pure Dart calculation engine
│   │   └── history_entry.dart      # Data model for history items
│   ├── providers/
│   │   ├── calculator_provider.dart # State management + history persistence
│   │   └── theme_provider.dart      # Dark/light mode with persistence
│   ├── screens/
│   │   └── calculator_screen.dart   # Root screen scaffold
│   ├── widgets/
│   │   ├── display_panel.dart       # Top display — expression + result
│   │   ├── button_grid.dart         # Full button layout grid
│   │   ├── calc_button.dart         # Individual button with animations
│   │   └── history_drawer.dart      # Side drawer with history list
│   ├── theme/
│   │   └── app_theme.dart           # Color palette + typography
│   └── utils/
│       └── number_utils.dart        # Number formatting helpers
├── assets/
│   └── fonts/
│       ├── JetBrainsMono-Regular.ttf
│       └── JetBrainsMono-Bold.ttf
├── android/                         # Android platform files
├── ios/                             # iOS platform files
├── pubspec.yaml                     # Dependencies & asset declarations
├── analysis_options.yaml            # Lint rules
└── README.md
```

---

## 🛠️ Technologies Used

| Technology | Purpose |
|------------|---------|
| **Flutter 3** | Cross-platform UI framework |
| **Dart 3** | Programming language |
| **Provider** | State management |
| **SharedPreferences** | Persistent storage |
| **Google Fonts** | Outfit typeface |
| **flutter_animate** | Animation utilities |
| **JetBrains Mono** | Display font (bundled) |

---

## 🧠 Architecture Overview

```
UI Layer (Widgets)
    │  listens to
    ▼
Provider Layer (ChangeNotifier)
    │  calls
    ▼
Logic Layer (Pure Dart)
    │  reads/writes
    ▼
Persistence (SharedPreferences)
```

The `CalculatorLogic` class is a pure Dart class with **zero Flutter dependencies** — it can be unit tested independently. The `CalculatorProvider` bridges logic with the UI and handles side effects (history persistence, animation triggers).

---

## 🎨 Design Decisions

- **Dark first** — the default dark theme uses a deep navy background (`#0A0E1A`) with electric cyan (`#00E5FF`) and violet (`#B040FF`) neon accents, evoking a premium OLED aesthetic.
- **JetBrains Mono** for the display ensures every digit is perfectly monospaced — critical for alignment as numbers change.
- **Scale + glow on press** — each button physically shrinks slightly and emits a colored glow shadow matching its function type.
- **Live result preview** — shows the evaluated result in real time below the main display, a UX pattern from modern iOS/Android calculators.

---

## 👤 Author

**Your Name**
- GitHub: [@YOUR_USERNAME](https://github.com/YOUR_USERNAME)
- Email: you@example.com

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2024 Your Name

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software...
```

---

<p align="center">Made with ❤️ and Flutter</p>
