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
  <img src="docs/image/collection_tab.png" width="30%" alt="Collection Tab" />
  <img src="docs/image/deck_formats_display.png" width="30%" alt="Deck Builder & Banlists" />
  <img src="docs/image/card_detail.png" width="30%" alt="Card Detail View" />
</p>

### 📸 Features Showcase Gallery

| Collection View | Card Detail & TCGPlayer | Statistics & Insights |
| :---: | :---: | :---: |
| <img src="docs/image/collection_tab.png" width="250" alt="Collection Tab" /> | <img src="docs/image/collection_and_tcgplayer_button.png" width="250" alt="Card Detail" /> | <img src="docs/image/stats_tab.png" width="250" alt="Statistics Tab" /> |
| *Search, filter & browse card catalog* | *Detailed stats, inventory & TCGPlayer link* | *Total cards, top sets, newest/oldest cards* |

| Deck Builder & Banlists | Deck Editing Mode | Empty Deck Options |
| :---: | :---: | :---: |
| <img src="docs/image/deck_formats_display.png" width="250" alt="Banlists Display" /> | <img src="docs/image/deck_build.png" width="250" alt="Deck Builder" /> | <img src="docs/image/deck_tab_no_loaded.png" width="250" alt="Empty Deck View" /> |
| *TCG, OCG, GOAT & EDISON banlist badges* | *Add/remove cards in Main, Extra & Side decks* | *Create new deck or import .ydk files* |

| Add to Collection | Open External Files | Login & Cloud Sync |
| :---: | :---: | :---: |
| <img src="docs/image/add_to_collection.png" width="250" alt="Add to Collection" /> | <img src="docs/image/open_with.png" width="250" alt="Open File" /> | <img src="docs/image/login.png" width="250" alt="Login Screen" /> |
| *Manage card printings, sets & rarities* | *Direct .YDK file association* | *Google Sign-in & Guest Mode* |

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
