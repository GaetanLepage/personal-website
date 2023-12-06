{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    packages.${system} = with pkgs; {
      default = writeShellApplication {
        name = "serve";
        runtimeInputs = [hugo];
        text = "hugo serve";
      };

      deploy = writeShellApplication {
        name = "deploy";
        runtimeInputs = [hugo rsync];
        text = ''
          hugo

          rsync -rv --delete \
            public/ \
            server:/var/www/personal_website/
        '';
      };
    };
  };
}
