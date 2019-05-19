#!/usr/bin/env bash

echo -e "Adding Esy Packages to Path..."
cd /root/esy-cache
mkdir -p bin
for esyDir in $(echo $PATH | tr ":" "\n" | grep "/root/.esy/")
do
  for esyFile in $(ls $esyDir | grep -E "\\b(bdump|cppo|dune|jbuilder|menhir|ocaml|ocamlbuild|ocamlc|ocamlcmt|ocamlcp|ocamldebug|ocamldep|ocamldoc|ocamlfind|ocamllex|ocamlmerlin|ocamlmerlin-reason|ocamlmerlin-server|ocamlmklib|ocamlmktop|ocamlobjinfo|ocamlopt|ocamloptp|ocamlprof|ocamlrun|ocamlrund|ocamlruni|ocamlyacc|odoc|refmt|refmterr|refmttype|substs|utftrip|ydump)\$")
  do
    ln -sf $esyDir/$esyFile /root/esy-cache/bin/$esyFile && echo "Added to Path: $esyDir/$esyFile"
  done
done
