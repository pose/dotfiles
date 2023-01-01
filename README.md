## Bootstrapping

To bootstrap a new box, execute:

```sh
git clone https://github.com/andsens/homeshick.git "$HOME/.homesick/repos/homeshick"
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
homeshick clone pose/dotfiles

# Execute specific macOS bootstrapping
[[ $OSTYPE == *"darwin"* ]] && bootstrap-macos.sh
```

## Testing

An empty Docker container is used to verify that the bootstrapping works
correctly. Execute:

```sh
cd test && ./run-test.sh
```
