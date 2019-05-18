# Dockerfile
FROM node:12

RUN apt-get update && npm install -g yarn
RUN yarn global add esy

WORKDIR /root/esy-cache/
COPY esy.json esy.json

RUN esy add ocaml
RUN esy build

RUN esy add @opam/dune
RUN esy build

RUN esy add @opam/merlin
RUN esy build

RUN esy add @opam/odoc
RUN esy build

RUN esy add @esy-ocaml/reason
RUN esy build

RUN esy add refmterr
RUN esy build

WORKDIR /
