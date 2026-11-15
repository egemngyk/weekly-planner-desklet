# Weekly Planner (Cinnamon Desklet)

<p align="center">
  <img src="weekly-planner@egemngyk/icon.png" width="96" height="96" alt="Weekly Planner Desklet Icon" />
</p>

<p align="center">
  <strong>A flexible, feature-rich weekly planner for Linux Mint Cinnamon, with independent instances, recurring tasks, and date-specific entries.</strong>
</p>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#installation">Installation</a> •
  <a href="#usage">Usage</a> •
  <a href="#language">Language</a> •
  <a href="#data-model-and-isolation">Data Model</a> •
  <a href="#supported-versions">Supported Versions</a> •
  <a href="#license">License</a>
</p>

---

## Features

- **Independent Instances**: Add multiple desklets, each with its own entries, appearance, and configuration.
- **Bilingual Interface**: Available in English (default) and Turkish, with independent language settings for each instance.
- **Entry Management**:
  - Add, edit, and delete entries.
  - Add notes and choose custom colors using palette swatches.
  - Mark entries as To-do or Important.
  - Track completion without deleting entries.
- **Drag & Drop Reordering**:
  - Reorder entries within the same day.
  - Move entries between different days.
  - Live reordering while dragging.
- **Weekly Navigation**:
  - Navigate between weeks using previous and next buttons.
  - Jump back to the current week with the Today button.
  - Display recurring and date-specific entries together.
- **Flexible Layout**:
  - Seven responsive day columns.
  - Horizontal scrolling when columns reach their minimum width.
  - Adjustable width, height, and UI scale.
- **Configurable Appearance**:
  - Language, layout, colors, frame, transparency, and title formats.
  - Compact mode and other display options.
- **JSON Entry Editor**:
  - Edit entries directly through the settings window.
  - Reload entries, open the JSON file in a text editor, and format JSON.
- **Persistent Data Storage**: Entries and settings remain intact when the desklet is removed, reinstalled, or Cinnamon is restarted.

---

## Installation

### Quick Install / Update

Run the installation script from the project directory:

```bash
./install.sh
```

The script installs the desklet into:

```text
~/.local/share/cinnamon/desklets/
```

Then add the desklet to your desktop:

1. Open **System Settings → Desklets**.
2. Find **Weekly Planner** in the list.
3. Click **+** to add it to your desktop.
4. Add as many instances as you need. Each instance starts with its own independent data.

If the desklet does not appear, restart Cinnamon using `Alt+F2`, type `r`, and press Enter.

### Uninstall

```bash
./install.sh --uninstall
```

### Reset Settings

```bash
./install.sh --reset-settings
```

This reinstalls the desklet and clears stale settings files from previous attempts.

---

## Usage

### 1. Add Entries

Press the **+** button in the header to create a new entry.

The entry is added to the bottom of the selected day. The selected day is highlighted with an accent-colored border.

By default, the selected day is today, or the first visible day.

### 2. Edit and Delete Entries

Click an entry to open its editing dialog.

Available options include:

- **Title**: Entry title.
- **Notes**: Additional information.
- **Color**: Choose a color from the available palette.
- **To-do**: Enable a completion checkbox.
- **Important**: Highlight the entry with a star.

Deleting an entry requires confirmation.

### 3. Reorder Entries

Use the drag handle (`≡`) to move entries.

- Reorder entries within the same day.
- Move entries to another day by dragging them onto it.
- Entries move live while dragging.

### 4. Complete Tasks

Click the checkbox (`☐` / `☑`) to toggle a To-do entry's completion status.

Completed entries remain visible and are not deleted.

### 5. Navigate Between Weeks

Use the header controls:

- **‹ / ›**: Navigate to the previous or next week.
- **Today**: Return to the current week.

Weekly recurring and date-specific entries are displayed together.

### 6. Configure the Desklet

Open the Configure window by right-clicking the desklet and selecting **Configure**, or by using the gear button in System Settings.

The settings are organized into two sections:

- **General**: Language, layout, size, UI scale, colors, frame, and title formats.
- **Entries**: JSON editor, reload actions, text editor access, JSON formatting, visible days, and content options.

### 7. Resize the Desklet

Resize the desklet using the mouse:

- Drag the right edge (`⋮`) to change width.
- Drag the bottom edge (`⋯`) to change height.
- Drag the bottom-right corner (`◢`) to change both.

The right-click menu also provides:

- Width +60 / -60
- Height +60 / -60
- Go to this week

---

## Language

The interface supports **English** and **Turkish**.

To change the language:

1. Open **Configure → General**.
2. Find the **Language** option.
3. Select English or Turkish.

The change applies immediately to:

- Week title
- Day names
- Buttons
- Dialogs
- Right-click menu

Language is an independent per-instance setting, so different desklets can use different languages.

The Configure window itself always uses English setting names.

---

## Data Model and Isolation

Each desklet instance stores its own settings and entries independently.

### Settings

Appearance and configuration settings are stored in:

```text
~/.local/share/weekly-planner-desklet/settings-<id>.json
```

A `settings.json` fallback is also supported.

Cinnamon spice configuration is stored in:

```text
~/.config/cinnamon/spices/weekly-planner@egemngyk/<id>.json
```

### Entries

Entry data is stored in:

```text
~/.local/share/weekly-planner-desklet/entries-<id>.json
```

A shared `entries.json` fallback is also supported.

Additional data protection features include:

- Atomic writes to prevent incomplete saves.
- Previous versions retained as backup files (`<id>.json~`).
- Corrupted files moved aside with a `.corrupt-<timestamp>` suffix.

### JSON Structure

The JSON data model supports weekly recurring entries and date-specific entries in one file.

- `options`: Available color palette and usage help.
- `_example`: Reference task template, never displayed on the desklet.
- `weekly`: Recurring tasks for each day (`monday` through `sunday`).
- `dates`: Date-specific tasks using the `YYYY-MM-DD` format.

Entries created using the **+** button are added to the `dates` section.

Both recurring and date-specific entries are combined and displayed on the corresponding days.

Removing or reinstalling the desklet does not delete stored entries or settings.

---

## Supported Versions

- **Target**: Cinnamon 5.x and 6.x (Linux Mint 21/22).
- **Compatibility**: Expected to work with Cinnamon 4.x, but not verified.
- **Week Start**: Monday.
- **Settings Interface**: Uses Cinnamon's native `layout` engine with two pages (General and Entries).

The desklet uses native Cinnamon APIs, including:

- `Desklet`
- `DeskletSettings`
- `ModalDialog`
- `St`

There are no Node.js, Electron, or web dependencies required to run the desklet.

---

## Development and Debugging

### Run Model Tests

Model logic can be tested without Cinnamon:

```bash
node tests/model.test.js
```

These tests run independently and do not modify `desklet.js`.

### Apply Changes

After modifying the source code:

```bash
./install.sh
```

Then restart Cinnamon using `Alt+F2` → `r`.

### View Logs

Available debugging options:

- `Alt+F2` → `lg` → Looking Glass → Logs.
- `journalctl -f | grep -i weekly-planner`
- `~/.xsession-errors`

If the desklet fails to start, the error is displayed on the desktop in red and written to the log.

### Reset a Single Instance

To reset an individual instance's data, delete its corresponding `<desklet_id>.json` file.

---

## Troubleshooting

### Configure Window Won't Open or Shows an "!" Icon

Try the following steps:

1. Run `./install.sh --reset-settings`.
2. Remove the old desklet instance from the desktop.
3. Restart Cinnamon using `Alt+F2` → `r`.
4. Add the desklet again from System Settings → Desklets.

---

## License

This project is licensed under the [MIT License](LICENSE).
