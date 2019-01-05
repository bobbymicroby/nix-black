
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
  users.extraUsers.bobby = {
  createHome=true;
  extraGroups  = ["wheel" "video" "audio" "disk" "networkmanager"];
  group = "users";
  home  ="/home/bobby";
  isNormalUser = true;
  uid = 1000;
  }; 

nixpkgs.config.allowUnfree = true;  

services.xserver = {

enable=true;


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
        
    
windowManager.xmonad = {

enable = true;
enableContribAndExtras = true;
};


}; 



  environment.systemPackages = with pkgs; [
vim git 
  ];

  system.stateVersion = "18.09"; 

}
