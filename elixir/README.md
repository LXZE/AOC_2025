# AOC Elixir Template

## Installation
Just cloning this repo and start working on your own solution

## Command
- Generate template 
```sh
mix gen <year> <day>
```
- Generate template and downloading the input from AoC (require .env file and aoc cookie session)
```sh
mix gen <year> <day> -dl
# or mix gen <year> <day> --download
```

- Download input from AoC
```sh
mix download <year> <day>
```

- Run solution on test input
```sh
mix aoc.test <year> <day>
# or mix aoc.test lib/solutions/<year>/<day> which is called by .vscode/tasks.json
```

- Run solution on actual input
```sh
mix aoc.run <year> <day>
# or mix aoc.run lib/solutions/<year>/<day> which is called by .vscode/tasks.json
```

## Config with VS Code
Edit your keyboard shortcut to invoke predefined tasks by adding these config into your `keybindings.json`
```json
{
  "key": "cmd+r", // feel free to change
  "command": "workbench.action.tasks.runTask",
  "args": "run test elixir", // must be the same inside `.vscode/tasks.json`
  "when": "editorLangId == elixir"
},
{
  "key": "cmd+shift+r",
  "command": "workbench.action.tasks.runTask",
  "args": "run full elixir",
  "when": "editorLangId == elixir"
}
```