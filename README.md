# 🎛️ WIDGET//CTL — settings app for the widgets

![macOS](https://img.shields.io/badge/macOS-Übersicht-3ef0ff?style=flat-square&logo=apple&logoColor=white&labelColor=040914) ![Vibecoded](https://img.shields.io/badge/vibecoded-with%20Claude-ff5ad9?style=flat-square&labelColor=040914)

A small menu-bar app that arranges and themes every widget in this collection. It writes one file, `~/Library/Application Support/STUDYTERM/widgets.json`, which every widget reads on its next refresh. After each change Übersicht is told to refresh, so you see it at once.

| File | What |
|:--|:--|
| `WidgetCTL.swift` | The native shell: menu-bar icon (▦), global hotkey `⌃⌥⌘S`, a window hosting the UI |
| `ctl.html` | The UI: grid editor, themes, the widget registry |
| `hotkey/` | The `⌃⌥⌘W` show/hide helper ([below](#️-hotkey)) |
| `Info.plist` · `icon.png` | App bundle metadata and icon |

## What it does

- **Layout:** drag widgets on a grid that mirrors your screen. They snap to 230 px columns with 12 px gaps; dropping on another widget swaps or bounces it. Drag one to the tray to store it (hidden), drag it back to deploy it. **RESET LAYOUT** restores the default stack.
- **Theme:** 16 colour schemes (cyan, amber, matrix, vapor, sunset, ice, gold, royal, marble, pastel, rose, ink, forest, ocean, rainbow, vice) × 8 styles (terminal, crt, glass, minimal, marble, paper, bold, vice). Set them for all widgets at once or per widget.
- **Hotkeys:** `⌃⌥⌘S` opens and closes the window; Esc or ✕ closes it. Show / hide all widgets is `⌃⌥⌘W` (see [Hotkey](#️-hotkey) below).

## Build

`install.command` in this repo builds it for you. By hand:

```bash
swiftc -O WidgetCTL.swift -o WidgetCTL -framework Cocoa -framework WebKit -framework Carbon
# then bundle: WidgetCTL.app/Contents/{MacOS/WidgetCTL, Resources/ctl.html, Info.plist}
```

## Adding a widget

Add a line to `const WIDGETS = [...]` in `ctl.html` (`id` must match the widget's `W_ID`, plus size and default grid cell), then rebuild.


## ⌨️ Hotkey

Also in this repo, in [`hotkey/`](hotkey): press **`⌃⌥⌘W`** anywhere to hide every widget, and again to bring them back. The games pause while hidden.

| File | What |
|:--|:--|
| `hotkey/widget-hotkey.swift` | Tiny background helper that registers `⌃⌥⌘W` through the Carbon hotkey API, so no Accessibility permission is needed. A LaunchAgent starts it at login. |
| `hotkey/widgets-toggle.sh` | The same toggle as a shell script, e.g. for a Shortcuts action or a Stream Deck button |

It creates or removes `~/Library/Application Support/STUDYTERM/hidden` and tells Übersicht to refresh. Every widget checks for that file first.

## 🚀 Install

1. Install the widgets you want first. Each widget repo has its own `install.command`, or use install-all in [vibecoded](https://github.com/SlicingReaper/vibecoded).
2. Download this repo and double-click **`install.command`**. It compiles WIDGET//CTL into `/Applications`, compiles the hotkey helper, and starts both at login.

- **Needs:** macOS 13+ · Xcode Command Line Tools for `swiftc` (`xcode-select --install`)
- **Remove:** quit WIDGET//CTL, delete `/Applications/WidgetCTL.app` and `~/Library/LaunchAgents/com.felix.widgetctl.plist` + `com.felix.studyterm.hotkey.plist`.

## 🧩 Part of a collection

This widget is one of twelve that share the same retro-terminal look, the same theming and the same show/hide hotkey. Each works on its own; together they make a desktop dashboard.

| | Widget | What |
|:-:|:--|:--|
| 💰 | [**WALLET//Ð**](https://github.com/SlicingReaper/points-wallet-widget) | Points wallet: earn for habits, spend on rewards, lock savings, keep a streak |
| 🔥 | [**75//HARD**](https://github.com/SlicingReaper/75-hard-widget) | 75 Hard challenge tracker: 7 daily tasks, day counter, auto-fail on a missed day |
| ⏱️ | [**STUDY//TERM**](https://github.com/SlicingReaper/study-timer-widget) | Study stopwatch that logs what you did, with a stats page and points |
| ✎ | [**NOTE//PAD**](https://github.com/SlicingReaper/notepad-widget) | Checklist notes with deadline countdowns, auto-expiry and a bin |
| “ | [**QUOTE//DAY**](https://github.com/SlicingReaper/quote-of-the-day-widget) | A new quote every midnight from a pool of 300, with likes and your own quotes |
| ▦ | [**TETRIS//GRID**](https://github.com/SlicingReaper/tetris-widget) | Tetris on the desktop: hold, ghost piece, levels, best score |
| ◉ | [**PONG//SOLO**](https://github.com/SlicingReaper/pong-widget) | Single-player Pong: keep the ball up, it speeds up every hit |
| ◎ | [**PONG//DUO**](https://github.com/SlicingReaper/pong-duo-widget) | Two-player Pong, 3 widgets wide: W/S vs ↑/↓, first to 7 |
| ⊞ | [**2048//TILE**](https://github.com/SlicingReaper/2048-widget) | 2048 with undo, keyboard or drag, saved between sessions |
| ⌂ | [**OUTPOST//**](https://github.com/SlicingReaper/outpost-colony-widget) | Colony-trading game: claim land, outfit robots, trade against 3 AI rivals |
| ☠ | [**DOOM//TERM**](https://github.com/SlicingReaper/doom-widget) | DOOM shareware Episode 1 in a 2-column widget: WebAssembly engine, savegames kept |
| 🎛️ | [**WIDGET//CTL**](https://github.com/SlicingReaper/widgetctl) ← you are here | Menu-bar app that arranges and themes all the widgets, plus a ⌃⌥⌘W show/hide hotkey |

**Install all of them at once:** [`vibecoded` → install-all.command](https://github.com/SlicingReaper/vibecoded) · 🤖 Vibecoded with [Claude](https://claude.ai): I designed, directed and tested it, the AI wrote most of the code.
