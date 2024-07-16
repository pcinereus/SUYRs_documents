{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/e11142026e2cef35ea52c9205703823df225c947.tar.gz") {} }:

with pkgs;

let
  my-pkgs = rWrapper.override {
    packages = with rPackages; [ tidyverse cmdstanr dplyr ggplot2 R];
  };
in
mkShell {
  buildInputs = [my-pkgs];
}