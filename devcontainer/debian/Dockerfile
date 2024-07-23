FROM debian:12-slim

ARG DEST=/usr/local/bin
ARG WORK_DIR=/tmp
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
  vim-gtk3 \
  tmux \
  bash-completion \
  wget \
  make \
  fzf \
  zoxide \
  ranger \
  highlight \
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
  prettier \
  intelephense \
  typescript \
  @vue/language-server

# Install rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

# Install lsp packages
RUN go install golang.org/x/tools/gopls@latest \
  && ln -s /home/$USERNAME/go/bin/gopls $DEST/gopls \
  && rustup component add rust-analyzer \
  && ln -s /home/$USERNAME/.cargo/bin/rust-analyzer $DEST/rust-analyzer \
  && NVM_CURRENT=$(nvm current) \
  && ln -s /home/$USERNAME/.nvm/versions/node/$NVM_CURRENT/bin/tsserver $DEST/tsserver \
  && ln -s /home/$USERNAME/.nvm/versions/node/$NVM_CURRENT/bin/intelephense $DEST/intelephense \
  && ln -s /home/$USERNAME/.nvm/versions/node/$NVM_CURRENT/bin/vue-language-server $DEST/vue-language-server \
  && ln -s /home/$USERNAME/.nvm/versions/node/$NVM_CURRENT/lib/node_modules/typescript/lib/ $DEST/typescript-lib

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

ARG DOTFILES=https://github.com/ranta0/dotfiles
RUN git clone $DOTFILES ~/dotfiles \
  && rm ~/.bashrc \
  && ln -s ~/dotfiles/.bashrc ~/.bashrc \
  && ln -s ~/dotfiles/.bash_aliases ~/.bash_aliases \
  && ln -s ~/dotfiles/.vimrc ~/.vimrc \
  && ln -s ~/dotfiles/.gitconfig ~/.gitconfig \
  && ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf

ARG NVIM_CONFIG=https://github.com/ranta0/nvim
RUN mkdir -p .config/nvim \
  && git clone $NVIM_CONFIG .config/nvim \
  && chown $USERNAME:$USERNAME .config/nvim

# Install nvim packages
# this is not working as intended
RUN nvim --headless "+Lazy! sync" +qa \
  && nvim --headless "+MasonToolsInstallSync" +qa

# Install vim packages
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
  && vim +PlugInstall +qall

CMD ["bash"]
