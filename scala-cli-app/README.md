This flake builds your app in 4 different ways:

```shell
# as a regular JVM app
nix run .#jvm

# as a GraalVM native image
nix run .#graal

# as a Scala Native compiled binary
nix run .#native

# as a Scala.js compiled node app
nix run .#node

# the default target is the JVM
nix run
```

Whether or not a given platform is supported depends on
how your app is written and what dependencies it has.
