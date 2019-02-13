
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

cabal-install
cabal2nix
emacs
unrar
unzip

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
       xrdb "${pkgs.writeText  "xrdb.conf" ''
       xterm*Background: black
       xterm*Foreground: white
       
       ''}"
    '';
  



}; 

programs.zsh = {
  enable = true;
  ohMyZsh.enable = true;
  ohMyZsh.plugins = [ "git" ];
  ohMyZsh.theme = "robbyrussell";  
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
