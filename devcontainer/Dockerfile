FROM debian:stable-slim

ARG DEST=/usr/local/bin

RUN apt-get update \
  && apt-get install -y \
  build-essential \
  ca-certificates \
  software-properties-common \
  cron \
  curl \
  gettext \
  sudo \
  libtool \
  libtool-bin \
  autoconf \
  automake \
  cmake \
  g++ \
  pkg-config \
  unzip \
  curl \
  git \
  scdoc \
  xclip \
  libevent-dev \
  libgraph-easy-perl \
  lsb-release \
  ripgrep \
  jq \
  vim \
  tmux \
  bash-completion \
  wget \
  yq \
  make \
  fzf \
  zoxide \
  # kubectx \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ARG PHP_VERSION=8.3
RUN /bin/sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' \
  && wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add

RUN apt-get update \
  && apt-get install php$PHP_VERSION -y

WORKDIR /opt
# Compile nvim
# RUN git clone https://github.com/neovim/neovim \
#   && cd neovim \
#   && git checkout stable \
#   && make CMAKE_BUILD_TYPE=Release \
#   && make install

# Latest stable neovim release
ARG NVIM_VERSION=0.9.4
RUN curl -sLo nvim-linux64.tar.gz "https://github.com/neovim/neovim/releases/download/v$NVIM_VERSION/nvim-linux64.tar.gz" \
  && tar xzf nvim-linux64.tar.gz \
  && ln -s /opt/nvim-linux64/bin/nvim $DEST/nvim

ARG GO_VERSION=1.22.0
RUN curl -sLo go$GO_VERSION.linux-amd64.tar.gz "https://go.dev//dl/go$GO_VERSION.linux-amd64.tar.gz" \
  && rm -rf /usr/local/go \
  && tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz

# Install kubectl
# RUN curl -sL "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o "$DEST/kubectl" && chmod +x "$DEST/kubectl"

# Install Azure CLI
# RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

ARG NODE_VERSION=lts
# Install specific Node.js
RUN curl -fsSL "https://deb.nodesource.com/setup_$NODE_VERSION.x" | bash - && apt-get install -y nodejs
# Install nvm manager (maybe)
# RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash 

# Install global npm modules for Node.js
RUN npm install -g \
  eslint \
  prettier

# Set up user
ARG USERNAME=dev
ARG UID=1000
RUN adduser \
  --uid $UID \
  --quiet \
  --shell /bin/bash \
  --home /home/$USERNAME \
  --gecos "dev" \
  $USERNAME

RUN passwd -d $USERNAME
RUN usermod -aG sudo $USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME
ENV TERM xterm-256color

# Autocompletion
RUN curl -o ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
RUN printf "if [ -f /etc/bash_completion ]; then \n. /etc/bash_completion\nfi" .bash_profile

ARG NVIM_CONFIG=https://github.com/ranta0/nvim
RUN mkdir -p .config/nvim \
  && git clone $NVIM_CONFIG .config/nvim \
  && chown $USERNAME:$USERNAME .config/nvim

# Install nvim packages
# this is not working as intended
RUN nvim --headless "+Lazy! sync" +qa \
 && nvim --headless "+MasonToolsInstallSync" +qa

CMD ["bash"]
