
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

users.extraUsers.bobby = {
createHome=true;
extraGroups  = ["wheel" "docker" "video" "audio" "disk" "networkmanager"];
group = "users";
home  ="/home/bobby";
isNormalUser = true;
uid = 1000;
}; 

hardware.pulseaudio.enable = true;
hardware.pulseaudio.support32Bit = true;

hardware.opengl.driSupport32Bit = true;

nixpkgs.config.allowUnfree = true;  



environment.systemPackages = with pkgs; [
vim
gitFull 
htop
which
file
];


services.upower.enable = true;

services.xserver = {

layout = "us,bg(phonetic)";
xkbOptions = "grp:ctrl_shift_toggle";


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



}; 

programs.zsh = {
  enable = true;
  autosuggestions.enable = true;
  ohMyZsh.enable = true;
  ohMyZsh.plugins = [ "git" ];
  ohMyZsh.theme = "frisk";  
  syntaxHighlighting.enable = true;
};

users.defaultUserShell = pkgs.zsh;

  system.stateVersion = "18.09"; 

}
