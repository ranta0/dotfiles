FROM debian:12-slim

ARG DEST=/usr/local/bin
ARG WORK_DIR=/opt
WORKDIR $WORK_DIR

RUN apt-get update \
  && apt-get install --no-install-recommends -y \
  gnupg \
  g++ \
  ca-certificates \
  software-properties-common \
  openssh-client \
  curl \
  gettext \
  sudo \
  pkg-config \
  unzip \
  curl \
  git \
  scdoc \
  xclip \
  lsb-release \
  ripgrep \
  jq \
  tmux \
  bash-completion \
  wget \
  fzf \
  zoxide \
  ranger \
  highlight \
  htop \
  make \
  clang \
  libtool-bin \
  libxt-dev \
  libncurses-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Set up user
ARG USERNAME=test-dev
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

# Install vim
RUN git clone https://github.com/vim/vim.git $WORK_DIR/vim \
  && cd $WORK_DIR/vim/src \
  && make install

ARG PHP_VERSION=8.3
RUN /bin/sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' \
  && wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add

RUN apt-get update \
  && apt-get install php$PHP_VERSION -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install composer
RUN EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')" \
  && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php -r "if (hash_file('sha384', 'composer-setup.php') === '$EXPECTED_CHECKSUM') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
  && php composer-setup.php \
  && php -r "unlink('composer-setup.php');" \
  && ln -s $WORK_DIR/composer.phar $DEST/composer

ARG GO_VERSION=1.22.0
RUN curl -sLo go$GO_VERSION.linux-amd64.tar.gz "https://go.dev//dl/go$GO_VERSION.linux-amd64.tar.gz" \
  && rm -rf /usr/local/go \
  && tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz

# # Install kubectl
# RUN curl -sL "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o "$DEST/kubectl" \
#   && chmod +x "$DEST/kubectl"

# # Install Azure CLI
# RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash -s -- -y

# neovim release
ARG NVIM_VERSION=0.10.0
RUN curl -sLo nvim-linux64.tar.gz "https://github.com/neovim/neovim/releases/download/v$NVIM_VERSION/nvim-linux64.tar.gz" \
  && tar xzf nvim-linux64.tar.gz \
  && ln -s $WORK_DIR/nvim-linux64/bin/nvim $DEST/nvim

# glow - terminal md renderer
ARG GLOW_VERSION=1.5.1
RUN curl -sLO "https://github.com/charmbracelet/glow/releases/download/v${GLOW_VERSION}/glow_${GLOW_VERSION}_amd64.deb" \
  && dpkg -i "./glow_${GLOW_VERSION}_amd64.deb"

RUN rm -rf /tmp/\* /var/tmp/* \
  && rm -rf $WORK_DIR/*.deb $WORK_DIR/*.tar.gz

USER $USERNAME
WORKDIR /home/$USERNAME
ENV TERM xterm-256color

ARG NVM_DIR=/home/$USERNAME/.nvm
ARG NODE_VERSION=20.15.1
ARG NVM_VERSION=0.39.7
# Install nvm with node and npm
RUN git clone https://github.com/nvm-sh/nvm.git .nvm \
  && cd .nvm && git checkout v$NVM_VERSION \
  && . ./nvm.sh \
  && nvm install v$NODE_VERSION \
  && nvm alias default v$NODE_VERSION \
  && nvm use default

# Install rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

# Install lsp packages
RUN /usr/local/go/bin/go install golang.org/x/tools/gopls@latest \
  && sudo ln -s /home/$USERNAME/go/bin/gopls $DEST/gopls \
  && /home/$USERNAME/.cargo/bin/rustup component add rust-analyzer \
  && sudo ln -s /home/$USERNAME/.cargo/bin/rust-analyzer $DEST/rust-analyzer

# # Install krew
# RUN set -x; cd "$(mktemp -d)" \
#   && OS="$(uname | tr '[:upper:]' '[:lower:]')" \
#   && ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" \
#   && KREW="krew-${OS}_${ARCH}" \
#   && curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" \
#   && tar zxvf "${KREW}.tar.gz" \
#   && ./"${KREW}" install krew

# Autocompletion
RUN curl -o ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

# Setting up env
ARG DOTFILES=https://github.com/ranta0/dotfiles
RUN git clone $DOTFILES ~/dotfiles \
  && rm ~/.bashrc \
  && ln -s ~/dotfiles/.bashrc ~/.bashrc \
  && ln -s ~/dotfiles/.bash_aliases ~/.bash_aliases \
  && ln -s ~/dotfiles/.vimrc ~/.vimrc \
  && ln -s ~/dotfiles/.gitconfig ~/.gitconfig \
  && ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf \
  && ln -s ~/dotfiles/plug.lock ~/plug.lock \
  && mkdir -p ~/.vim/ \
  && ln -s ~/dotfiles/.vim/coc-settings.json ~/.vim/coc-settings.json \
  && mkdir -p ~/.config/ \
  && ln -s ~/dotfiles/.config/nvim ~/.config/nvim

# Install vim packages
RUN vim +PlugInstall +qall
RUN nvim +PlugInstall +qa
RUN nvim +PlugInstall +qa

CMD ["bash"]
