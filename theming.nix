{ pkgs, ... }: {
  # Qt applications should use the GTK theme
  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };
  
  # Cursor configuration
  home.pointerCursor = {
    gtk.enable = true;
    # You can use Bibata cursors or another cursor theme
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 20;
  };
  
  # GTK theme configuration
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "mauve";
      };
      name = "Papirus-Dark";
    };
    theme = {
      name = "Catppuccin-Mocha-Standard-Mauve-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["mauve"];
        variant = "mocha";
        size = "standard";
      };
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
}
