This flake builds your Scala app in 4 different ways:

```shell
# as a regular JVM app
nix run .#jvm

# as a GraalVM native image
nix run .#graal

# as a Scala Native compiled native binary
nix run .#native

# as a Scala.js compiled Node.js app
nix run .#node
```

Whether or not a given platform is supported depends on
how your app is written and what dependencies it has.
You can easily remove unsupported platforms from the flake:
see `supported-platforms` in `flake.nix`.

Some platforms have multiple outputs for different
levels of optimization. See `nix flake show` for
a complete list of outputs.

