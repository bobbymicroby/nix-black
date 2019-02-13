
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

       XTerm*faceName:             xft:Dejavu Sans Mono for Powerline:size=11
       XTerm*utf8:                 2

       #define S_base03        #002b36
#define S_base02        #073642
#define S_base01        #586e75
#define S_base00        #657b83
#define S_base0         #839496
#define S_base1         #93a1a1
#define S_base2         #eee8d5
#define S_base3         #fdf6e3

*background:            S_base03
*foreground:            S_base0
*fadeColor:             S_base03
*cursorColor:           S_base1
*pointerColorBackground:S_base01
*pointerColorForeground:S_base1

#define S_yellow        #b58900
#define S_orange        #cb4b16
#define S_red           #dc322f
#define S_magenta       #d33682
#define S_violet        #6c71c4
#define S_blue          #268bd2
#define S_cyan          #2aa198
#define S_green         #859900

!! black dark/light
*color0:                S_base02
*color8:                S_base03

!! red dark/light
*color1:                S_red
*color9:                S_orange

!! green dark/light
*color2:                S_green
*color10:               S_base01

!! yellow dark/light
*color3:                S_yellow
*color11:               S_base00

!! blue dark/light
*color4:                S_blue
*color12:               S_base0

!! magenta dark/light
*color5:                S_magenta
*color13:               S_violet

!! cyan dark/light
*color6:                S_cyan
*color14:               S_base1

!! white dark/light
*color7:                S_base2
*color15: S_base3
               

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
