# NameplateModifier

A lightweight modifier for the default Blizzard nameplates in World of Warcraft 3.3.5a. Lets you customize fonts, textures, colors, and adds debuff tracking.

<img width="372" height="168" alt="Namnlös" src="https://github.com/user-attachments/assets/15a40529-a835-4163-8bd3-9911f1c032c9" />

## Features

- **Bar texture** — swap the health and cast bar texture from a list of bundled options or any LibSharedMedia texture installed by other addons
- **Health border color** — recolor the nameplate's gold border to any RGBA value
- **Hide elements** — individually hide the health border, cast border, elite indicator, and uninterruptible cast shield
- **Health text** — show health as percent, min/max, deficit, or nothing, with full font/shadow customization
- **Cast text** — show cast progress as current/max, current, percent, time left, or nothing, with full font/shadow customization
- **Name & level text** — independently configure font, size, outline, and shadow for the name and level strings
- **Debuffs** — show debuffs you cast on a unit as a row of icons above the nameplate, with configurable size, position offset, and timer font/shadow settings

## Installation

1. Download or clone this repository
2. Copy the `Nameplates` folder into `World of Warcraft/Interface/AddOns/`
3. Restart the game or reload the UI (`/reload`)
4. Enable the addon from the character select screen

## Usage

Open the options panel with any of these slash commands:

```
/np
/nameplate
/nameplates
```

The panel is also available under **Interface → AddOns → Nameplates** in the default Blizzard options menu.

## Options

### General

| Option | Description |
|---|---|
| Show nameplate visibility status | Prints a chat message when nameplate visibility is toggled via keybind |
| Bar texture | The texture used for health and cast bars |
| Health border color | RGBA color of the nameplate border frame |
| Hide health bar border | Hides the gold border around the health bar (requires UI reload to show again) |
| Hide cast bar border | Hides the border around the cast bar (requires UI reload to show again) |
| Hide elite indicator | Hides the dragon icon for elite mobs (requires UI reload to show again) |
| Hide cast uninterruptible shield | Hides the shield icon on non-interruptible casts (requires UI reload to show again) |

### Cast/Health Text

Configures the text shown on the health bar and cast bar, with options for display style (percent, min/max, deficit, current/max, time left) and full font, outline, and shadow settings.

### Name Text / Level Text

Independently configure the font, size, outline style, and shadow for the unit name and level strings on each nameplate.

### Debuffs

| Option | Description |
|---|---|
| Show debuffs | Enable or disable debuff icon display |
| Icon size | Size of each debuff icon in pixels (8–32) |
| Icon offset X | Horizontal position offset of the icon row |
| Icon offset Y | Vertical position offset of the icon row |
| Font, outline, shadow | Full text settings for the countdown timer on each icon |

Debuffs are shown as a row of up to 8 icons above the nameplate. Only debuffs cast by you are shown. Icons display a countdown timer that updates in real time.

## Notes

- Debuff detection uses `UNIT_AURA`, `PLAYER_TARGET_CHANGED`, `UPDATE_MOUSEOVER_UNIT`, and `UNIT_TARGET` events. Icons appear as soon as you target or mouse over a unit you have debuffed — no combat log parsing is required.
- The `nameplate1`–`nameplate40` unit tokens used by some other addons do not exist in 3.3.5a and are not used here.
- All settings are saved per character profile via AceDB. Use the **Profiles** tab in the options panel to share or copy settings between characters.

## Localization

The addon ships with translations for English (enUS), Simplified Chinese (zhCN), Traditional Chinese (zhTW), and Korean (koKR). New strings added by this fork fall back to English on non-English clients if no translation is provided.

## Credits

Original addon by **Shadowed** (Shadow, Horde, Mal'Ganis US). Extended with health border color, debuff tracking, and additional text customization options.
