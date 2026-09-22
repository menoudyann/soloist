# Soloist

Soloist is a lightweight macOS menu bar app that keeps one application visible at a time. It is designed for focused work and for workflows that use transparent or translucent application windows, where seeing other apps behind the active one is distracting.

## How it works

When Soloist is enabled, it hides every other visible macOS application. Whenever you switch to another application, Soloist hides the previous one so your new active app is the only application on screen.

Disabling Soloist restores only the applications it hid. Applications that were already hidden remain untouched.

## Requirements

- macOS 14 Sonoma or later
- Xcode 16 or later to build from source

## Install

Soloist is currently distributed as source code.

1. Clone this repository.
2. Run `./Scripts/build-app.sh`.
3. Open `Build/Soloist.app`.
4. The Soloist icon will appear in the menu bar.

Alternatively, open `Package.swift` in Xcode, select the `Soloist` executable scheme, and run it.

## Usage

1. Click the Soloist icon in the menu bar.
2. Choose **Enable Soloist**.
3. Work normally and switch apps as needed. Soloist keeps the active app visible and hides the rest.
4. Choose **Disable Soloist** to restore the apps Soloist hid.

## Architecture

The project follows Clean Architecture with dependencies directed toward the domain:

| Layer | Responsibility |
| --- | --- |
| `Domain` | Application models and repository/observer contracts. |
| `Application` | The `FocusModeService` use case and focus-state rules. |
| `Infrastructure` | AppKit and `NSWorkspace` implementations that interact with macOS. |
| `Presentation` | SwiftUI menu bar UI and its view model. |

The focus rules are independent from AppKit and covered by unit tests using test doubles.

## Development

Build the project with:

```sh
swift build
```

Run the tests with:

```sh
swift test
```

To produce an application bundle for the current architecture:

```sh
./Scripts/build-app.sh
```

## Limitations

- Soloist manages regular macOS applications only. It does not control desktop widgets, Finder desktop icons, menu bar items, or system overlays.
- Apps that explicitly refuse macOS hide requests may remain visible.

## Contributing

Issues and pull requests are welcome. For behavior changes, please include tests for the `FocusModeService` when practical.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).
