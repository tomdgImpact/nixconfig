# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, callPackage, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };
  environment.pathsToLink = ["/libexec"];
  # Configure keymap in X11
  services.xserver = {
    layout = "fr";
    xkbVariant = "";
    enable = true;
   
    desktopManager = {
	xterm.enable = false;
	wallpaper = {
		combineScreens = false;
		mode = "scale";
	};
    };
    displayManager = {
	defaultSession = "none+i3";
    };

    windowManager.i3 = {
	enable = true;
	extraPackages = with pkgs; [
	   dmenu
	   i3status
	   i3lock
	];
    };
  };
  nixpkgs.config.pulseaudio = true;
  # Configure console keymap
  console.keyMap = "fr";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.impactsec = {
    isNormalUser = true;
    description = "Impactsec";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
    packages = with pkgs; [];
  };
  # Bluetooth setting and sound
  sound.enable = true;
  hardware = {
	pulseaudio = {
		enable = true;
		package = pkgs.pulseaudioFull;
	};
	bluetooth = {
		enable = true;
		settings = {
			General = {
				Enable = "Source, Sink, Media, Socket";
			};
		};
	};
	ckb-next.enable = true;
	opengl = {
		enable = true;
		driSupport32Bit = true;
		setLdLibraryPath = true;
	};
  };
  services.blueman.enable = true;
  services.mmsd.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    bluez
    git
    brave
    discord
    firefox
    polybar
    python311
    python311Packages.pip
    python311Packages.jupyterlab
    ansible
    jupyter
    gcc
    gdb
    docker
    kubectl
    terraform  
    xfce.thunar
    gparted
    nitrogen
    clipit
    flameshot
    pavucontrol
    jetbrains-toolbox
    vscode
    nodejs_20
    rustup
    ghidra-bin
    teams
    qbittorrent
    oh-my-zsh
    zsh-powerlevel10k
    tmux
    xterm
    bat
    rofi
    htop
    podman
    cmake
    clang
    clang-tools
    arandr
    rust-analyzer
    neofetch
    dunst
    usbutils
    # synthing  # package for file synchro, homemade cloud storage ?
    xorg.xkill
    killall
    dnsmasq
    # tailscale # mesh vpn built on wireguard 
    opensnitch-ui
    openssl
    ngrok
    unzip
    feh
    gnumake
    xclip
    pkgconfig
    podman
    noisetorch
    # package to handle virtualization
    virt-manager
    libvirt
    qemu
    virtualbox
    dconf
    alacritty
    clightd
    lm_sensors
    redshift
    cpuid
    mpd
    xfce.xfce4-battery-plugin
    xbattbar
    xorg.xbacklight
  ];
  
  # set zsh as default shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];
  fonts.fonts = with pkgs; [
	(nerdfonts.override { fonts = [ "UbuntuMono" ]; })
  ];

  programs.noisetorch.enable = true;
  programs.dconf.enable = true;
  # polkit
  security.polkit.enable = true; 
  # vm setup config
  virtualisation.libvirtd = {
	enable = true;
	onBoot = "ignore";
	onShutdown = "shutdown";
	qemu.ovmf.enable = true;
	qemu.runAsRoot = true;
  };

  # virtualization with container 
  virtualisation = {
	docker = {
		enable = true;
		rootless = {
			enable = true;
			setSocketVariable = true;
		};
	};
        podman = {
		enable = true;
		# Create a 'docker' alias for podman, to use it as a drop-in replacement
		# dockerCompat = true;
		
		# Required for containers under podman-compose to be able to talk to each other.
		defaultNetwork.settings = {
			dns_enable = true;
		};
	};
  }; 
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
