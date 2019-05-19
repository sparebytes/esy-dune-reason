FROM node:12

# Configure apt
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
   && apt-get -y install --no-install-recommends apt-utils 2>&1

# Verify git and process tools are installed
RUN apt-get install -y git procps

# Remove outdated yarn from /opt and install via package 
# so it can be easily updated via apt-get upgrade yarn
RUN rm -rf /opt/yarn-* \
    && rm -f /usr/local/bin/yarn \
    && rm -f /usr/local/bin/yarnpkg \
    && apt-get install -y curl apt-transport-https lsb-release \
    && curl -sS https://dl.yarnpkg.com/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/pubkey.gpg | apt-key add - 2>/dev/null \
    && echo "deb https://dl.yarnpkg.com/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get -y install --no-install-recommends yarn

# Install Esy
RUN yarn global add esy

# Install Common Esy Packages
WORKDIR /root/esy-cache
RUN echo "{}" > esy.json
RUN esy add ocaml && esy build
RUN esy add \
      @opam/dune \
      @opam/merlin \
      @opam/odoc \
      @esy-ocaml/reason \
      refmterr \
   && esy build

# Setup Esy PATH
COPY esy-paths.sh esy-paths.sh
RUN esy bash ./esy-paths.sh
ENV PATH="/root/esy-cache/bin:${PATH}"

# Install bs-platform
RUN yarn global add bs-platform

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
ENV DEBIAN_FRONTEND=dialog
