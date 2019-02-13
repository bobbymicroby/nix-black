
{ config, pkgs, ... }:

{
imports =
  [ 
    ./hardware-configuration.nix
];

boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;
boot.initrd.luks.devices = [
 {
  name = "root";
  device = "/dev/disk/by-uuid/37804d89-4c68-42e1-99fd-22deef9b525d";
  preLVM = true;
 }
];
   
networking.networkmanager.enable = true;
networking.hostName = "black-nixos";

time.timeZone = "Europe/Sofia";

virtualisation.docker.enable = true;


hardware.pulseaudio.enable = true;
hardware.pulseaudio.support32Bit = true;

hardware.opengl.driSupport32Bit = true;

nixpkgs.config.allowUnfree = true;  

programs.adb.enable = true;

environment.systemPackages = with pkgs; [

(pkgs.vim_configurable.customize {
      name = "vim";
      vimrcConfig.vam.pluginDictionaries = [
        # vim-nix handles indentation better but does not perform sanity
        { names = [ "vim-addon-nix" ]; ft_regex = "^nix\$"; }
];
})

gitFull 
htop
which
file
firefox
cabal-install
cabal2nix
emacs
unrar
unzip
glibc
patchelf
];


services.upower.enable = true;

services.xserver = {

layout = "us,bg(phonetic)";
xkbOptions = "grp:lwin_toggle";


enable=true;

autoRepeatDelay = 300;
autoRepeatInterval = 50;

displayManager = {

slim = {

defaultUser = "bobby";
enable = true;

};

};

videoDrivers = [ "nvidia" ];
dpi = 160;

monitorSection = ''
      DisplaySize 401 171
    '';

screenSection = ''
    Option "DPI" "160 x 160"
    '';
        
 windowManager = {
    xmonad.enable = true;
    xmonad.extraPackages = hpkgs: [
      hpkgs.taffybar
      hpkgs.xmonad-contrib
      hpkgs.xmonad-extras
    ];
    default = "xmonad";
  };    
displayManager.sessionCommands =  ''
       xset r rate 300 50 
           
       xrdb "${pkgs.writeText  "xrdb.conf" ''
       
       #define S_base03        #002b36
       #define S_base02        #073642
       #define S_base01        #586e75
       #define S_base00        #657b83
       #define S_base0         #839496
       #define S_base1         #93a1a1
       #define S_base2         #eee8d5
       #define S_base3         #fdf6e3
       #define S_yellow        #b58900
       #define S_orange        #cb4b16
       #define S_red           #dc322f
       #define S_magenta       #d33682
       #define S_violet        #6c71c4
       #define S_blue          #268bd2
       #define S_cyan          #2aa198
       #define S_green         #859900



       XTerm*faceName:             xft:Dejavu Sans Mono for Powerline:size=11
       XTerm*utf8:                 2

       
       XTerm*background:            S_base03
       XTerm*foreground:            S_base0
       XTerm*fadeColor:             S_base03
       XTerm*cursorColor:           S_base1
       XTerm*pointerColorBackground:S_base01
       XTerm*pointerColorForeground:S_base1

       !! black dark/light
       XTerm*color0:                S_base02
       XTerm*color8:                S_base03

       !! red dark/light
       XTerm*color1:                S_red
       XTerm*color9:                S_orange

       !! green dark/light
       XTerm*color2:                S_green
       XTerm*color10:               S_base01

       !! yellow dark/light
       XTerm*color3:                S_yellow
       XTerm*color11:               S_base00

       !! blue dark/light
       XTerm*color4:                S_blue
       XTerm*color12:               S_base0

       !! magenta dark/light
       XTerm*color5:                S_magenta
       XTerm*color13:               S_violet

       !! cyan dark/light
       XTerm*color6:                S_cyan
       XTerm*color14:               S_base1

       !! white dark/light
       XTerm*color7:                S_base2
       XTerm*color15: S_base3
               

       Xft*antialias:              true
       Xft*hinting:                full  
       Xft.antialias: 1
       Xft.autohint: 1
       Xft.hintstyle: hintslight 
       ''}"
    '';
  



}; 

fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      dejavu_fonts
      powerline-fonts
      source-code-pro
      terminus_font
    ];
};

programs.ssh = {
 startAgent = true;

};  

programs.zsh = {
  shellAliases = {
  ff = "firefox &>/dev/null &";
  };  
  enable = true;
  ohMyZsh.enable = true;
  ohMyZsh.plugins = [ "git" ];
  ohMyZsh.theme = "agnoster";  
  syntaxHighlighting.enable = true;
};

users.defaultUserShell = pkgs.zsh;


users.extraUsers.bobby = {
createHome=true;
extraGroups  = ["wheel" "docker" "video" "audio" "disk" "networkmanager"];
group = "users";
home  ="/home/bobby";
isNormalUser = true;
uid = 1000;
}; 


  system.stateVersion = "18.09"; 

}
