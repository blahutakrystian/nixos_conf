{ lib, config, pkgs, ... }:
{
  
  imports = [ ./theming.nix ];

  home.username = "krystian";
  home.homeDirectory = "/home/krystian";

  # Set cursor size and DPI for 4K monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };
  
  # Environment variables for GTK theming
  home.sessionVariables = {
    GTK_THEME = "Catppuccin-Mocha-Standard-Mauve-Dark";
    GTK_USE_PORTAL = "1";
  };

  # User packages
  home.packages = with pkgs; [
    # Desktop environment tools
    wezterm            # Terminal
    rofi-wayland       # Application launcher
    waybar             # Status bar
    dunst              # Notifications
    libnotify          # Notification library
    swww               # Wallpaper
    slurp              # Screen capture
    pavucontrol        # Audio control
    wl-clipboard       # Clipboard management
    vscodium
    zed-editor

    
    # Fonts and icons
    font-awesome
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    material-design-icons
    
    # Utilities
    lm_sensors
    playerctl
    spotify
    swaylock-effects
    swayidle
    ticktick
    keepassxc
    fastfetch
    btop
    peaclock
    easyeffects
    tidal-hifi
    unzip
    librewolf

    dolphin-emu
    
    # Theming
    catppuccin-gtk
    papirus-icon-theme
  ];


  # Git configuration
  programs.git = {
    enable = true;
    userName = "blahutakrystian";
    userEmail = "blahutakrystian@gmail.com";
    
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      credential.helper = "store";
    };
  };

  # Neovim configuration
  programs.nvf = {
    enable = true;
    defaultEditor = true;
    settings = {
      vim.theme = {
        enable = true;
        name = "catppuccin";
        style = "mocha";
      };
      
      vim.languages = {
        nix.enable = true;
        rust.enable = true;
        python.enable = true;
        enableLSP = true;
        enableTreesitter = true;
      };
      
      vim.treesitter = {
        enable = true;
        indent.enable = false;
        highlight.enable = true;
        incrementalSelection.enable = true;
      };

      vim.autocomplete.nvim-cmp.enable = true;
      vim.telescope.enable = true;

      vim.options = {
        number = true;
        relativenumber = false;

        tabstop = 2;
        softtabstop = 2;
        shiftwidth = 2;
        expandtab = true;
        smartindent = true;
        autoindent = true;
      };

      # File Explorer (NvimTree)
      vim.filetree.nvimTree = {
        enable = true;
        openOnSetup = true;
        mappings = {
          toggle = "<C-n>";
          focus = "<C-f>";
          refresh = "<C-r>";
          findFile = "<C-g>";
        };          
        setupOpts = {
          git.enable = true;
          actions = {
            open_file = {
              quit_on_open = false;
              resize_window = true;
            };
          };
          filters.dotfiles = false;
        };
      };
      
      vim.statusline.lualine.enable = true;
    };
  };

  # Rofi configuration
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "${pkgs.wezterm}/bin/wezterm"; 
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      drun-display-format = "{name}";
      disable-history = false;
      sidebar-mode = false;
      columns = 1;
      font = "JetBrainsMono Nerd Font 14"; 
      width = 30;
      lines = 10;
      line-padding = 10;
      element-padding = 10;
    };
  };

  # Wezterm configuration
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local config = {}

      if wezterm.config_builder then
        config = wezterm.config_builder()
      end

      config.color_scheme = 'Catppuccin Mocha'

      -- Font configuration with explicit family name
      config.font = wezterm.font_with_fallback({
        {
          family = 'JetBrainsMono Nerd Font',
          weight = 'Medium',
        },
        -- Fallback fonts if needed
        'Noto Sans Mono',
      })
      config.font_size = 13.0
      
      -- Window configuration
      config.window_background_opacity = 0.85
      config.window_decorations = "NONE"
      config.enable_tab_bar = true
      config.hide_tab_bar_if_only_one_tab = true
      config.window_padding = {
        left = 20,
        right = 20,
        top = 20,
        bottom = 20,
      }

      return config
    '';
  };
  
  # Waybar configuration
  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
      target = "hyprland-session.target";
    };
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 34;
        spacing = 4;
        
        modules-left = ["hyprland/workspaces" "custom/playerctl#backward" "custom/playerctl#play" "custom/playerctl#foward" "custom/playerlabel"];
        modules-center = ["clock" "cpu" "temperature" "memory"];
        modules-right = ["pulseaudio" "bluetooth" "network" "tray"];
        
        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
          sort-by-number = true;
        };

        "custom/playerctl#backward"= {
          format= "󰙣 "; 
          on-click= "playerctl previous";
          on-scroll-up = "playerctl volume .05+";
          on-scroll-down = "playerctl volume .05-";
        };
        "custom/playerctl#play"= {
          format= "{icon}";
          return-type= "json";
          exec= "playerctl -a metadata --format '{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
          on-click= "playerctl play-pause";
          on-scroll-up = "playerctl volume .05+";
          on-scroll-down = "playerctl volume .05-";
          format-icons= {
            Playing = "<span>󰏥 </span>";
            Paused = "<span> </span>";
            Stopped = "<span> </span>";
          };
        };
        "custom/playerctl#foward"= {
          format= "󰙡 ";
          on-click= "playerctl next";
          on-scroll-up = "playerctl volume .05+";
          on-scroll-down = "playerctl volume .05-";
        };
        "custom/playerlabel"= {
          format= "<span>󰎈 {} 󰎈</span>";
          return-type= "json";
          max-length= 40;
          exec = "playerctl -a metadata --format '{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
          on-click= "spotify";
        };
        
        "clock" = {
          format = "󰥔 {:%H:%M  %d/%m/%Y}";
          tooltip-format = ''
            <big>{:%Y}</big>
            <tt><small>{calendar}</small></tt>'';
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            first-day-of-week = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
        };
        
        "network" = {
          format-wifi = "󰤨 {essid}";
          format-ethernet = "󰈁 Connected";
          format-disconnected = "󰤭 Disconnected";
          format-linked = "󰤪 {essid} (No IP)";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)";
          tooltip-format-ethernet = "{ifname}: {ipaddr}/{cidr}";
          tooltip-format-disconnected = "Disconnected";
          max-length = 50;
          on-click = "nm-connection-editor";
        };        
        
        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = "󰝟 Muted";
          format-icons = {
            headphone = "󰋋";
            headset = "󰋎";
            portable = "󰏲";
            default = ["󰕿" "󰖀" "󰕾"];
          };
          on-click = "pavucontrol";
        };

        "bluetooth" = {
          format = "󰂯";
          format-disabled = "󰂲";
          format-connected = "󰂱 {device_alias}";
          tooltip-format = "{controller_alias}\t{controller_address}";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          on-click = "blueman-manager";
        };

        "cpu" = {
          format = "󰻠 {usage}%";
          format-alt = "󰻠 {avg_frequency:0.1f}GHz";
          interval = 1;
          tooltip = true;
        };

        "temperature" = {
          format = "󰔏 {temperatureC}°C";
          format-critical = "󱃂 {temperatureC}°C";
          critical-threshold = 80;
          interval = 2;
          tooltip = false;
        };

        "memory" = {
          format = "󰍛 {percentage}%";
          format-alt = "󰍛 {used:0.1f}GB";
          interval = 2;
          tooltip = true;
          tooltip-format = "Used: {used:0.1f}GB\nAvailable: {avail:0.1f}GB\nTotal: {total:0.1f}GB";
        };
        
        "tray" = {
          icon-size = 21;
          spacing = 10;
        };
      };
    };
    
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        color: #ffffff;
      }
      
      window#waybar {
        background: rgba(0, 0, 0, 0.2);
        border-radius: 0;
      }

      #clock {
        background-color: rgba(30, 30, 46, 0.3);
        padding: 0 10px;
        margin: 0 5px;
        border-radius: 8px;
      }

      #workspaces button {
        padding: 0 5px;
        color: #ffffff;
        background: transparent;
      }

      #workspaces button.active {
        background-color: rgba(30, 30, 46, 0.3);
        border-radius: 8px;
      }

      #tray {
        padding: 0 10px;
      }

      #network, #pulseaudio {
        padding: 0 10px;
        background-color: rgba(30, 30, 46, 0.3);
        margin: 0 2px;
        border-radius: 8px;
      }  

      #bluetooth {
        padding: 0 10px;
        background-color: rgba(30, 30, 46, 0.3);
        margin: 0 2px;
        border-radius: 8px;
      }

      #cpu, #temperature, #memory {
        padding: 0 10px;
        background-color: rgba(30, 30, 46, 0.3);
        margin: 0 2px;
        border-radius: 8px;
      }

      #temperature.critical {
        background-color: rgba(235, 77, 75, 0.7);
      }
      
      #custom-playerctl.backward, #custom-playerctl.play, #custom-playerctl.foward {
        background-color: rgba(30, 30, 46, 0.3);
        font-size: 22px;
      }

      #custom-playerctl.backward:hover, #custom-playerctl.play:hover, #custom-playerctl.foward:hover {
        color: #ffffff;
      }

      #custom-playerctl.backward {
        color: #b4befe;
        border-radius: 24px 0px 0px 10px;
        padding-left: 16px;
        margin-left: 7px;
      }

      #custom-playerctl.play {
        color: #89b4fa;
        padding: 0 5px;
      }

      #custom-playerctl.foward {
        color: #b4befe;
        border-radius: 0px 10px 24px 0px;
        padding-right: 12px;
        margin-right: 7px;
      }

      #custom-playerlabel {
        background: rgba(30, 30, 46, 0.3);
        color: #ffffff;
        padding: 0 20px;
        border-radius: 24px 10px 24px 10px;
        margin: 5px 0;
        font-weight: bold;
      }  
    '';
  };

  # Hyprland configuration
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Monitor configuration
      monitor = [
        "DP-1, 3840x2160@98, 0x0, 1"
        "HDMI-A-2, disable"
      ];

      # Variables
      "$terminal" = "wezterm";
      "$fileManager" = "thunar";
      "$mainMod" = "SUPER";

      # General configuration
      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(cba6f7ee) rgba(89b4faee) 45deg";
        "col.inactive_border" = "rgba(313244aa)";
        resize_on_border = true;
        allow_tearing = false;
        layout = "dwindle";
      };

      # Decoration
      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      # Animations
      animations = {
        enabled = true;

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };

      # Layout configuration
      dwindle = {
        pseudotile = true;
        preserve_split = true;
        force_split = 2;
      };

      master = {
        new_status = "master";
      };

      # Misc settings
      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = false;
      };

      # Input configuration
      input = {
        kb_layout = "pl";
        kb_variant = "";
        kb_model = "";
        kb_options = "grp:alt_shift_toggle";
        kb_rules = "";
        follow_mouse = 1;
        sensitivity = 0;

        touchpad = {
          natural_scroll = false;
        };
      };

      # Gestures
      gestures = {
        workspace_swipe = false;
      };

      # Device-specific settings
      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      # Key bindings
      bind = [
        "$mainMod, T, exec, $terminal"
        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, togglefloating,"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod, S, exec, rofi -show drun -show-icons"
        "$mainMod, L, exec, swaylock --clock --indicator --screenshots --effect-blur 7x5"
        
        # Focus movement
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        
        # Workspace switching
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        
        # Move to workspace
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 10, movetoworkspace, 10"
        
        # Mouse bindings for workspace switching
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];

      # Mouse bindings
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # Media key bindings
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      # Media control bindings
      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      # Window rules
      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
    };
    
    extraConfig = ''
      exec-once = swww init
      exec-once = swww img ~/Wallpapers/m_v.png
      exec-once = waybar

      # Lock screen after inactivity
      exec-once = swayidle -w timeout 120 'swaylock --clock --indicator --screenshots --effect-blur 7x5' timeout 300 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep 'swaylock --clock --indicator --screenshots --effect-blur 7x5'
    '';
  };

  # Theme configuration
  catppuccin = {
    flavor = "mocha";
    rofi.enable = true;
  };
  
  
  # Services
  services = {
    dunst.enable = true;
  };

  # Swaylock configuration
  home.file.".config/swaylock/config".text = ''
    clock
    screenshots
    indicator
    effect-blur=7x5
    grace=2
    fade-in=0.2
    
    # Colors
    key-hl-color=00000066
    separator-color=00000000
    
    inside-color=00000033
    inside-clear-color=ffffff00
    inside-caps-lock-color=ffffff00
    inside-ver-color=ffffff00
    inside-wrong-color=ffffff00
    
    ring-color=ffffff
    ring-clear-color=ffffff
    ring-caps-lock-color=ffffff
    ring-ver-color=ffffff
    ring-wrong-color=ffffff
    
    line-color=00000000
    line-clear-color=ffffffFF
    line-caps-lock-color=ffffffFF
    line-ver-color=ffffffFF
    line-wrong-color=ffffffFF
    
    text-color=ffffff
    text-clear-color=ffffff
    text-ver-color=ffffff
    text-wrong-color=ffffff
    
    bs-hl-color=ffffff
    caps-lock-key-hl-color=ffffffFF
    caps-lock-bs-hl-color=ffffffFF
    text-caps-lock-color=ffffff
  '';

  # Home Manager state version
  home.stateVersion = "24.11";

  # Enable Home Manager
  programs.home-manager.enable = true;
  }
