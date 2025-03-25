# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./aliases.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-ftw"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # allows run unpatched dynamic binaries on NixOs (C# dev kit extension doesnt work on vs code)
  programs.nix-ld.enable = true;
  
  # Select internationalisation properties.
  i18n = {
    defaultLocale = "pl_PL.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pl_PL.UTF-8";
      LC_IDENTIFICATION = "pl_PL.UTF-8";
      LC_MEASUREMENT = "pl_PL.UTF-8";
      LC_MONETARY = "pl_PL.UTF-8";
      LC_NAME = "pl_PL.UTF-8";
      LC_NUMERIC = "pl_PL.UTF-8";
      LC_PAPER = "pl_PL.UTF-8";
      LC_TELEPHONE = "pl_PL.UTF-8";
      LC_TIME = "pl_PL.UTF-8";
    };
  };

 
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${pkgs.hyprland}/bin/Hyprland";
        user = "krystian";
      };
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Enable Thunar and required services
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  # Enable supporting services
  programs.xfconf.enable = true;  # For saving preferences
  services.gvfs.enable = true;    # For mount, trash, etc.
  services.tumbler.enable = true; # For thumbnails

  # Enable Flakes
  nix = {
    package = pkgs.nixVersions.stable;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
  
  # Allow unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "spotify"
      "ticktick"
      "vscode"
      "jetbrains.rider"
    ];

  # Wayland/Graphics Support
  hardware.graphics.enable = true;

  # Environment variables for Wayland
  environment.variables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  # XDG Portal
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Enable dconf at the system level
  programs.dconf.enable = true;

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Define a user account
  users.users.krystian = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "changeme";
  };

  # Firefox
  programs.firefox.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    # Basic utilities
    neovim
    wget
    git
    curl
    pciutils
    
    # System tools
    bluez
    pavucontrol
    
    # Wayland and GUI
    wayland
    wayland-utils
    wl-clipboard
    wezterm
    rofi-wayland
    waybar
    dunst
    libnotify
    swww
    networkmanagerapplet
    slurp
    swaylock-effects
    
    # Theming
    catppuccin-gtk
    papirus-icon-theme
    adwaita-icon-theme
  ];

  system.stateVersion = "24.11";
}
