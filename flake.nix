{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devshell.flakeModule
      ];

      systems = ["x86_64-linux"];

      perSystem = {
        config,
        pkgs,
        ...
      }: {
        formatter = pkgs.alejandra;
        devshells.default = {
          packages = with pkgs; [
            hugo
            rsync
          ];

          commands = [
            {
              name = "deploy";
              command = ''
                hugo

                rsync -rv --delete \
                  public/ \
                  server:/var/www/personal_website/
              '';
            }
            {
              name = "serve";
              command = "hugo serve";
            }
          ];
        };
      };
    };
}
