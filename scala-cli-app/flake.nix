{
  description = "My Scala app";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    devshell.url = "github:numtide/devshell";
    typelevel-nix.url = "github:typelevel/typelevel-nix";
    my-nix-utils.url = "github:buntec/nix-utils";
  };

  outputs = { self, nixpkgs, devshell, typelevel-nix, my-nix-utils, ... }:

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
        in {
          default = pkgs.devshell.mkShell {
            imports = [ typelevel-nix.typelevelShell ];
            name = "my-app-dev-shell";
            typelevelShell = {
              jdk.package = pkgs.jdk;
              nodejs.enable = true;
              native.enable = true;
              native.libraries = [ pkgs.zlib pkgs.s2n-tls pkgs.openssl ];
            };
            packages = with pkgs; [ coreutils which ];
          };
        });

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
