{
  description = "Bitstream Charter font family";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems       = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgsFor       = system: nixpkgs.legacyPackages.${system};

      makePkg = system:
        let pkgs = pkgsFor system;
        in pkgs.stdenvNoCC.mkDerivation {
          pname   = "bitstream-charter";
          version = "1.0.3";

          src = pkgs.fetchzip {
            url    = "https://github.com/davidseegert/Bitstream-Charter/archive/refs/heads/master.zip";
            sha256 = "1y3nkn8v0k5ln9pwimcyzgvwvkkz4r4bvv49i59l8a5pmqgcd6b4";
          };

          dontConfigure = true;
          dontBuild     = true;

          installPhase = ''
            runHook preInstall
            mkdir -p "$out/share/fonts/opentype/bitstream-charter"
            cp *.otf "$out/share/fonts/opentype/bitstream-charter/"
            runHook postInstall
          '';

          meta = with pkgs.lib; {
            description     = "Bitstream Charter serif font family";
            longDescription = ''
              Bitstream Charter was designed by Matthew Carter in 1987, optimised for
              low-resolution output. In 1992 Bitstream donated the original Type 1 sources
              to the X Consortium under a permissive license allowing free use, copying,
              modification, and redistribution. This package provides an OTF build derived
              from the x.org 1.0.3 release.
            '';
            homepage        = "https://github.com/davidseegert/Bitstream-Charter";
            license         = {
              fullName = "Bitstream Charter License";
              free     = true;
              url      = "https://github.com/davidseegert/Bitstream-Charter/blob/master/Copyright";
            };
            maintainers     = [ { name = "stuffbusy"; } ];
            platforms       = platforms.all;
          };
        };

    in
      {
        packages = forAllSystems (system: {
          bitstream-charter = makePkg system;
          default           = makePkg system;
        });

        overlays.default = final: _prev: {
          bitstream-charter = makePkg final.stdenv.hostPlatform.system;
        };

        nixosModules.default = { pkgs, ... }: {
          fonts.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.default ];
        };
      };
}
