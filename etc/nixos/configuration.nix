{ config, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
  ];

  boot.loader = {
    # EFI bootloader
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    grub.useOSProber = true;
  };

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  # Nvidia optimus support
  hardware.bumblebee.enable = true;
  hardware.bluetooth.enable = true;

  boot.plymouth = {
    enable = true;
    theme = "breeze";
  };

  services = {
    printing.enable = true;
    xserver.enable = true;
    xserver.layout = "us";
    xserver.libinput.enable = true;
    xserver.desktopManager.plasma5.enable = true;
    gpm.enable = true;
  };

  services.openssh = {
    enable = true;
  };

  services.xserver.displayManager.sddm = {
    enable = true;
    autoLogin.enable = true;
    autoLogin.user = "k";
  };

  nix.autoOptimiseStore = false;

  networking = {
    hostName = "rina";
    # wireless.enable = true; # wpa_supplicant.
    networkmanager.enable = true;
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  i18n = {
    #consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "all"
    ];
  };

  time.timeZone = "Europe/Moscow";
  nixpkgs.config.allowUnfree = true;
  system.autoUpgrade.enable = true;

  # "nix search pkgname" for search
  environment.systemPackages = with pkgs; [
    wget curl nano htop
    flatpak ncdu tree nox
    ntp nginx git plymouth
    gpm pciutils lm_sensors
    fuse ifuse sshfs-fuse
    python37Packages.pip
    python37Packages.setuptools

    latte-dock
    libsForQt5.qtstyleplugin-kvantum
    
    ark dolphin filelight
    gwenview kate kdenlive
    kcalc spectacle kcolorchooser
    kcontacts kdf kgpg
    kig kmix kompare
    konsole krfb kwalletmanager
    marble okteta okular
    youtube-dl vlc gparted
    firefox google-chrome transmission-gtk
  ];

  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = false;
  sound.enable = true;

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  users.users.k = {
    createHome = true;
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" ];
  };

  system.stateVersion = "19.03";
}
