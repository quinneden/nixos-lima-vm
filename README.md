## NixOS Lima VM

Forked from [kasuboski/nixos-lima](https://github.com/kasuboski/nixos-lima), still mostly identical,
slight modification in the user configuration and lima runtime.

## How-to
1. Build NixOS disk image from flake.
```bash
nix build .#packages.aarch64-linux.image
```
2. Once finished, execute ./copy.sh which will copy the image from the nix store
   into ./img and chmod 644, and renames file to match reference in nixos.yaml.
```bash
./scripts/copy.sh
```
3. Start Lima VM using configuration in nixos.yaml.
```bash
limactl start --name=nixos ./nixos.yaml
```
4. Execute vm shell and nixos-rebuild from this flake's nixosConfiguration.
```bash
nixos-rebuild switch --use-remote-sudo --flake github:quinneden/nixos-lima-vm#nixosConfigurations.nixos
```