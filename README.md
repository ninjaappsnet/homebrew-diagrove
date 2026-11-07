# diagrove for Homebrew

`diagrove` makes, reads, changes and draws [Diagrove](https://ninjaapps.net/apps/diagrove/) diagrams from the command line, for you and for programs such as AI agents. It can also change a diagram you have open in Diagrove on your Mac.

## Install

```sh
brew install ninjaappsnet/diagrove/diagrove
```

Or download `diagrove-<version>-macos.zip` from this repository's [releases](https://github.com/ninjaappsnet/homebrew-diagrove/releases/latest) and unzip it. Keep its files together, since `diagrove` reads the `.bundle` folders beside it, and link it into a folder on your `PATH`:

```sh
mkdir -p ~/.local/lib && mv ~/Downloads/diagrove-1.0.0-macos ~/.local/lib/diagrove
sudo ln -sf ~/.local/lib/diagrove/diagrove /usr/local/bin/diagrove
```

The binary is signed with NinjaApps' Developer ID and notarized by Apple. It needs macOS 26 or later, on Apple silicon or Intel.

## Check it works

```sh
diagrove --version
diagrove templates list
diagrove --help
```

## Use it with AI agents

- Claude Code: `diagrove skill install` puts the diagrove skill in `~/.claude/skills/diagrove`.
- Any MCP client: the command is `diagrove` and the argument is `mcp`.

## Change a diagram open in Diagrove

`--live` sends a command to the Diagrove app instead of a file: `diagrove text --live`, `diagrove apply --live ops.json`, `diagrove render --live -o picture.png`. The first time, macOS asks whether your terminal (or the AI app that runs diagrove) may control Diagrove. Allow it, or change it later in System Settings › Privacy & Security › Automation.

## Licences

The files in this repository are under the MIT licence (`LICENSE`). The `diagrove` binary is © 2026 NinjaApps. It includes third-party software whose licences come in the zip as `LICENSES.txt` and that `diagrove --licenses` prints.

Help and support: [ninjaapps.net/apps/diagrove/support](https://ninjaapps.net/apps/diagrove/support.html).
