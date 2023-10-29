{
  description = "My Scala app";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.devshell.url = "github:numtide/devshell";
  inputs.my-nix-utils.url = "github:buntec/nix-utils";

  outputs = { self, nixpkgs, devshell, my-nix-utils, ... }:

    let
      inherit (nixpkgs.lib) genAttrs;

      eachSystem = genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      version = if (self ? rev) then self.rev else "dirty";

    in {

      devShells = eachSystem (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ devshell.overlays.default ];
          };

          scalaDevShell = pkgs.devshell.mkShell {
            name = "scala-dev-shell";
            commands = with pkgs; [
              { package = scala-cli; }
              { package = sbt; }
              { package = nodejs; }
            ];
            packages = with pkgs; [
              jdk
              sbt
              scala-cli
              metals
              clang
              coreutils
              llvmPackages.libcxxabi
              openssl
              s2n-tls
              which
              zlib
            ];

            env = [
              {
                name = "JAVA_HOME";
                value = "${pkgs.jdk}";
              }
              {
                name = "LIBRARY_PATH";
                prefix = "$DEVSHELL_DIR/lib:${pkgs.openssl.out}/lib";
              }
              {
                name = "C_INCLUDE_PATH";
                prefix = "$DEVSHELL_DIR/include";
              }
              {
                name = "LLVM_BIN";
                value = "${pkgs.clang}/bin";
              }
            ];

          };
        in { default = scalaDevShell; });

      packages = eachSystem (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ ];
          };

          buildScalaApp = pkgs.callPackage my-nix-utils.lib.mkBuildScalaApp { };

        in buildScalaApp {
          inherit version;
          src = ./src;
          pname = "my-app";
          scala-native-version = "0.4.15";
          sha256 = "sha256-cePs7D0d5Y7iGKocA+S3Ik2qjm5Pu4mbAjbvohY0jdk=";
        }

      );

      checks = self.packages;

    };

}
