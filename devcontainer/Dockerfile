# Can I go smaller?
FROM debian:11-slim

ARG DEST=/usr/local/bin
ARG WORK_DIR=/tmp
WORKDIR $WORK_DIR

RUN apt-get update \
  && apt-get install --no-install-recommends -y \
  gnupg \
  build-essential \
  ca-certificates \
  software-properties-common \
  cron \
  openssh-client \
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
  make \
  fzf \
  zoxide \
  # kubectx \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

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

RUN passwd -d $USERNAME \
  && usermod -aG sudo $USERNAME

ARG PHP_VERSION=8.3
RUN /bin/sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' \
  && wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add

RUN apt-get update \
  && apt-get install php$PHP_VERSION -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ARG GO_VERSION=1.22.0
RUN curl -sLo go$GO_VERSION.linux-amd64.tar.gz "https://go.dev//dl/go$GO_VERSION.linux-amd64.tar.gz" \
  && rm -rf /usr/local/go \
  && tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz

# Install kubectl
# RUN curl -sL "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o "$DEST/kubectl" && chmod +x "$DEST/kubectl"

# Install Azure CLI
# RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Compile nvim
# RUN git clone https://github.com/neovim/neovim \
#   && cd neovim \
#   && git checkout stable \
#   && make CMAKE_BUILD_TYPE=Release \
#   && make install

# neovim release
ARG NVIM_VERSION=0.9.4
RUN curl -sLo nvim-linux64.tar.gz "https://github.com/neovim/neovim/releases/download/v$NVIM_VERSION/nvim-linux64.tar.gz" \
  && tar xzf nvim-linux64.tar.gz \
  && ln -s $WORK_DIR/nvim-linux64/bin/nvim $DEST/nvim

# glow - terminal md renderer
ARG GLOW_VERSION=1.5.1
RUN curl -sLO "https://github.com/charmbracelet/glow/releases/download/v${GLOW_VERSION}/glow_${GLOW_VERSION}_amd64.deb" \
  && dpkg -i "./glow_${GLOW_VERSION}_amd64.deb"

RUN rm -rf /tmp/\* /var/tmp/*

USER $USERNAME
WORKDIR /home/$USERNAME
ENV TERM xterm-256color

ENV NVM_DIR=/home/$USERNAME/.nvm 
ENV NODE_VERSION=20.10.0
ARG NVM_VERSION=0.39.7
# Install nvm with node and npm
RUN git clone https://github.com/nvm-sh/nvm.git .nvm \
  && cd .nvm && git checkout v$NVM_VERSION \
  && . ./nvm.sh \
  && nvm install v$NODE_VERSION \
  && nvm alias default v$NODE_VERSION \
  && nvm use default \
  && npm install -g \
  pnpm \
  eslint \
  prettier

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
