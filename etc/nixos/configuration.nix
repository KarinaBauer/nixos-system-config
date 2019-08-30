{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nvidia.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;

#   boot.initrd.luks.devices = [
#     {
#       name = "home";
#       device = "/dev/disk/by-uuid/ae395e98-c3b0-4203-8322-22985fdd970f";
#       preLVM = true;
#       # allowDiscards = true;
#     }
#   ];

  # let's have a bootsplash!
  boot.plymouth = {
    enable = true;

    #themePackages = with pkgs; [
    #  plymouth (breeze-plymouth.override {
    #    nixosBranding = true;
    #  })
    #];
    theme = "breeze";
  };

  nix.autoOptimiseStore = true;

  networking.hostName = "rina"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    #consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "all"
    ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  nixpkgs.config.allowUnfree = true;
  system.autoUpgrade.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget curl nano
    htop flatpak ncdu
    tree nox ntp
    nginx git plymouth
    pciutils

    fuse ifuse sshfs-fuse

    youtube-dl vlc gparted
    electrum chromium firefox

    latte-dock
    libsForQt5.qtstyleplugin-kvantum
    
    ark dolphin filelight
    gwenview kate kdenlive
    kcalc spectacle kcolorchooser
    kcontacts kdf kgpg
    kig kmix kompare
    konsole krfb kwalletmanager
    marble okteta okular
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # Enable the OpenSSH daemon.
  #services.openssh.enable = true;
  services.openssh = {
    enable = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  #services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.k = {
    createHome = true;
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" ];
  };

  services.xserver.displayManager.sddm = {
    enable = true;
    autoLogin.enable = true;
    autoLogin.user = "k";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?
}
