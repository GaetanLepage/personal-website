{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    apps.${system} = {
      default = {
        type = "app";
        program = let
          serve-script = pkgs.writeShellApplication {
            name = "serve";
            runtimeInputs = [pkgs.hugo];
            text = "hugo serve";
          };
        in "${serve-script}/bin/serve";
      };

      deploy = {
        type = "app";
        program = let
          deploy-script = pkgs.writeShellApplication {
            name = "deploy";
            runtimeInputs = with pkgs; [hugo rsync];
            text = ''
              hugo

              rsync -rv --delete \
                public/ \
                server:/var/www/personal_website/
            '';
          };
        in "${deploy-script}/bin/deploy";
      };
    };
  };
}
