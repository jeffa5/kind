{
  description = "Kubernetes performance tests";

  inputs = {
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      {
        packages.kind = pkgs.buildGoModule {
          pname = "kind";
          version = "0.1.0";
          src = ./.;
          vendorSha256 = "sha256-8o9jjE42+apy1R/BqDK/lE9iBFnz8hlbjVLIwLdiww4=";
          subPackages = [ "." ];
          # runTests = false;
        };

        defaultPackage = self.packages.${system}.kind;

        apps.kind = flake-utils.lib.mkApp {
          drv = self.packages.${system}.kind;
        };

        defaultApp = self.apps.${system}.kind;

        devShell = pkgs.mkShell {
          packages = with pkgs;
            [
              go_1_16

              nixpkgs-fmt
              rnix-lsp
            ];
        };
      });
}
