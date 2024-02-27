FROM debian:stable-slim

RUN apt-get update \
  && apt-get install -y \
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
  xdg-utils \
  tmux \
  make

# Install nvim
WORKDIR /opt
RUN git clone https://github.com/neovim/neovim \
  && cd neovim \
  && git checkout stable \
  && make CMAKE_BUILD_TYPE=Release \
  && make install


# Install specific Node.js
ARG NODEVER=lts
RUN curl -fsSL "https://deb.nodesource.com/setup_$NODEVER.x" | bash - && apt-get install -y nodejs

# Install global npm modules for Node.js
RUN npm install -g \
  eslint \
  prettier

# # Set up non-root user
ARG USERNAME=dev
ARG UID=1000
RUN adduser \
  --uid $UID \
  --quiet \
  --disabled-password \
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

ARG NVIM_CONFIG=https://github.com/ranta0/nvim
RUN mkdir -p .config/nvim \
  && git clone $NVIM_CONFIG .config/nvim \
  && chown $USERNAME:$USERNAME .config/nvim

RUN nvim --headless "+Lazy! sync" +qa

CMD ["bash"]
