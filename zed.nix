{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/d056063028f6cbe9b99c3a4b52fdad99573db3ab.tar.gz") {} }:

pkgs.zed-editor
