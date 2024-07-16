
let
 pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/019f5c29c5afeb215587e17bf1ec31dc1913595b.tar.gz") {};
 
  rpkgs = builtins.attrValues {
    inherit (pkgs.rPackages) 
      tidyverse
      rstan
      brms
      emmeans
      cmdstanr;
  };
    
  system_packages = builtins.attrValues {
    inherit (pkgs) 
      R
      glibcLocales
      nix;
  };
  
in

pkgs.mkShell {
  LOCALE_ARCHIVE = if pkgs.system == "x86_64-linux" then  "${pkgs.glibcLocales}/lib/locale/locale-archive" else "";
  LANG = "en_US.UTF-8";
   LC_ALL = "en_US.UTF-8";
   LC_TIME = "en_US.UTF-8";
   LC_MONETARY = "en_US.UTF-8";
   LC_PAPER = "en_US.UTF-8";
   LC_MEASUREMENT = "en_US.UTF-8";

  buildInputs = [  rpkgs  system_packages   ];
  
}
