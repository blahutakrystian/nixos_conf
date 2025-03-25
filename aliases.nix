# aliases.nix
{
  environment.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake /etc/nixos";
    upgrade = "sudo nix flake update --flake /etc/nixos && sudo nixos-rebuild switch --flake /etc/nixos";
    clean-old-builds = "sudo nix-collect-garbage --delete-older-than 3d";
  };
}
