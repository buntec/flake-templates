# flake-templates

A collection of nix flake templates

To show a list of available templates:
```shell
nix flake show github:buntec/flake-templates --refresh
```

To create a new project from a template:
```shell
nix flake new -t github:buntec/flake-templates#scala-cli-app ./my-new-project --refresh
```

# Notes
It is recommended to add `--refresh` to the commands above to ensure you always get the latest version.
