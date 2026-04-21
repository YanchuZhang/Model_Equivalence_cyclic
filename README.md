## Model Equivalence (Macaulay2)

Scripts to check model equivalence using Macaulay2. The core functions live in `main.m2`, with a minimal example in `example.m2`.

### Requirements
- macOS
- Macaulay2 installed (the `M2` executable should be on your PATH)

### Files
- `main.m2` — core routines (e.g., `checkEquivalence`)
- `example.m2` — small runnable example showing usage

### Quick start
Run interactively from a terminal:

```bash
M2
load "example.m2"
```

Or run the script non-interactively:

```bash
M2 --script example.m2
```

### Using VS Code (optional)
To send code directly from VS Code to a Macaulay2 terminal:

1) Add a Macaulay2 terminal profile pointing to your `M2` path (Apple Silicon example shown):

```json
{
	"terminal.integrated.profiles.osx": {
		"Macaulay2": { "path": "/opt/homebrew/bin/M2" }
	},
	"terminal.integrated.defaultProfile.osx": "Macaulay2"
}
```

2) Optionally add keybindings to run a selection or load the whole file:

```json
[
	{
		"key": "alt+enter",
		"command": "workbench.action.terminal.runSelectedText",
		"when": "editorTextFocus && resourceExtname == '.m2'"
	},
	{
		"key": "alt+shift+enter",
		"command": "workbench.action.terminal.sendSequence",
		"args": { "text": "load \"${file}\"\u000D" },
		"when": "editorTextFocus && resourceExtname == '.m2'"
	}
]
```

Usage tips:
- Open a new terminal using the “Macaulay2” profile before sending code.
- Save the file before using “load \"${file}\"”.

### Troubleshooting
- Error: The terminal process failed to launch: Path to shell executable "/Applications/Macaulay2-1.13/bin/m2" does not exist.
	- Update your VS Code terminal profile to the correct `M2` path (e.g., `/opt/homebrew/bin/M2` on Apple Silicon, `/usr/local/bin/M2` on Intel).
	- In VS Code: Command Palette → Terminal: Select Default Profile → choose “Macaulay2”.
	- Search and remove stale paths in settings if needed:

```bash
grep -R "/Applications/Macaulay2-1.13/bin/m2" \
	"$HOME/Library/Application Support/Code/User" \
	"$(pwd)/.vscode" 2>/dev/null || true
```

---

If you run into issues or have questions about the scripts, check `example.m2` first for a minimal working invocation.



