# bitstream-charter

A Nix flake packaging the [Bitstream Charter](https://github.com/davidseegert/Bitstream-Charter) serif font family for NixOS.

Charter was designed by Matthew Carter in 1987, optimised for low-resolution output devices. In 1992 Bitstream donated the original Type 1 sources to the X Consortium under a permissive licence allowing free use, copying, modification, and redistribution. This flake provides an OTF build derived from that x.org 1.0.3 release.

## Usage

Add the flake as an input:

```nix
inputs.bitstream-charter.url = "github:tichelmorres/bitstream-charter";
```

Then pick whichever integration suits your setup:

### A) NixOS module

Fonts are added to `fonts.packages` automatically.

```nix
nixosConfigurations.<host> = nixpkgs.lib.nixosSystem {
     modules = [
         inputs.bitstream-charter.nixosModules.default
     ];
};
```

### B) Overlay

Exposes `pkgs.bitstream-charter`.

```nix
nixpkgs.overlays = [ inputs.bitstream-charter.overlays.default ];
fonts.packages = [ pkgs.bitstream-charter ];
```

### C) Direct package reference

```nix
fonts.packages = [
     inputs.bitstream-charter.packages.${pkgs.stdenv.hostPlatform.system}.default
];
```

## Licence

The fonts are distributed under the original [Bitstream Charter Licence](https://github.com/davidseegert/Bitstream-Charter/blob/master/Copyright).

The Nix packaging in this repository is released under [MIT](https://opensource.org/licenses/MIT).
