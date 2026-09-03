# 🃏 YGOBINDER - Yu-Gi-Oh! Binder & Deck Builder

**YGOBinder** is a modern, responsive, offline-first Yu-Gi-Oh! card collection manager, binder, and deck builder application built with **Flutter**, **Riverpod**, **Drift (SQLite)**, and **Firebase Cloud Sync**.

---

## 📌 App Information

- **Current Version**: `1.0.1+13` (Version 1.0.1)
- **Developer**: Tsuna2001
- **Framework**: Flutter 3.x (Dart 3.x)
- **State Management**: Flutter Riverpod
- **Local Database**: Drift (SQLite)
- **Cloud Backend**: Firebase Authentication & Firestore Sync
- **Card Data Source**: YGOPRODeck API

---

## 📱 System Requirements

### 🤖 Android
- **Minimum OS Version**: Android 5.0 (Lollipop) / API Level 21+
- **Recommended OS Version**: Android 12+ / API Level 31+
- **Target SDK**: Android 14 (API Level 34)

### 🍎 iOS
- **Minimum OS Version**: iOS 13.0+
- **Recommended OS Version**: iOS 16.0+

### 💻 Desktop & Web (Local Mode)
- **Windows**: Windows 10+ (64-bit)
- **Linux**: Ubuntu 20.04+ / Debian 11+
- **macOS**: macOS 11.0 Big Sur+
- **Web**: Modern Web Browsers (Chrome, Firefox, Safari, Edge)

---

## ✨ Key Features

- 📚 **Collection & Binder Management**: Track your cards, quantities, conditions, rarities, set codes, purchase prices, and custom collection numbers.
- 🎴 **Interactive Deck Builder**:
  - Edit decks with live Main, Extra, and Side Deck grids and card counts.
  - Search catalog, add (`+ MAIN`, `+ EXTRA`, `+ SIDE`), and remove (`- REMOVE`) cards seamlessly in both landscape and portrait modes.
  - Create decks from scratch (`+ NEW DECK`) or import `.ydk` files.
  - Automatic replace-on-save for decks with duplicate names.
- ⭐ **Favorites & 📜 Wanted Cards**: Mark cards as favorites or wanted with instant local SQLite updates and Cloud Firestore sync.
- 🛍️ **TCGPlayer Direct Search**: Open any card directly in TCGPlayer search with a single tap (`Open in TCGPlayer`).
- 📊 **Collection Statistics**: Overview of total cards, unique cards, top sets, newest card owned, and oldest card owned.
- 📷 **Camera OCR Scanner**: Scan card set codes using Google ML Kit.
- ☁️ **Firebase Cloud Sync**: Cross-device sync for inventory, decks, favorites, and wanted cards.
- 📱 **Adaptive Responsive Layout**: Optimized for mobile phones (portrait/landscape), tablets, and desktop.

---

## 📱 Application Screenshots & Showcase

<p align="center">
  <img src="docs/image/Screenshot_20260902_230105.png" width="30%" alt="Collection Tab" />
  <img src="docs/image/Screenshot_20260902_230230.png" width="30%" alt="Deck Builder" />
  <img src="docs/image/Screenshot_20260902_230238.png" width="30%" alt="Card Detail View" />
</p>

### 📸 Features Showcase Gallery

| Collection & Cards | Interactive Deck Builder | Card Detail & TCGPlayer |
| :---: | :---: | :---: |
| <img src="docs/image/Screenshot_20260902_230105.png" width="250" alt="Collection" /> | <img src="docs/image/Screenshot_20260902_230230.png" width="250" alt="Deck Builder" /> | <img src="docs/image/Screenshot_20260902_230238.png" width="250" alt="Card Details" /> |
| *Browse cards with filters* | *Edit Main, Extra & Side Decks* | *Detailed stats, pricing & links* |

| Banlist Status & Badges | Collection Statistics | Filter Options |
| :---: | :---: | :---: |
| <img src="docs/image/Screenshot_20260902_230017.png" width="250" alt="Banlists" /> | <img src="docs/image/Screenshot_20260902_230045.png" width="250" alt="Stats" /> | <img src="docs/image/Screenshot_20260902_230113.png" width="250" alt="Filters" /> |
| *TCG / OCG / GOAT / EDISON badges* | *Overview of owned sets & cards* | *Filter by Favorites, Wanted, Edison* |

| Landscape Layout | Options & Legal Disclaimer | Favorites & Wanted Cards |
| :---: | :---: | :---: |
| <img src="docs/image/Screenshot_20260902_225955.png" width="250" alt="Landscape" /> | <img src="docs/image/Screenshot_20260902_230128.png" width="250" alt="Options" /> | <img src="docs/image/Screenshot_20260902_230119.png" width="250" alt="Favorites" /> |
| *Responsive 2-column view* | *Database management & Ko-fi support* | *Instant star & wanted poster badges* |

---

## ☕ Support the Project

If you enjoy using **YGOBinder** and would like to support its continued development, consider supporting me on Ko-fi!

[![Support on Ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/tsunas200121679)

👉 **[Support Tsuna2001 on Ko-fi](https://ko-fi.com/tsunas200121679)**

---

## ⚖️ Legal Disclaimer & Attribution

> [!IMPORTANT]
> **YGOBinder** is an **unofficial fan-made application** and is not affiliated with, endorsed by, or sponsored by **Konami Digital Entertainment**, **Studio Dice**, **SHUEISHA**, or **TV TOKYO**.

- **Yu-Gi-Oh! Trademarks & Copyrights**: All Yu-Gi-Oh! card text, imagery, artwork, graphics, and trademarks belong to **Studio Dice**, **SHUEISHA**, **TV TOKYO**, and **KONAMI**.
- **Card Data & Image Attribution**: All card information, prices, set lists, and card image assets are provided by the [YGOPRODeck API](https://ygoprodeck.com).
