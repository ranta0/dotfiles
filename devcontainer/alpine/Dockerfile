FROM alpine

ARG DEST=/usr/local/bin
ARG WORK_DIR=/tmp
WORKDIR $WORK_DIR

RUN apk update \
  && apk add --no-cache \
  bash \
  gnupg \
  openssh-client \
  curl \
  gettext \
  sudo \
  autoconf \
  automake \
  cmake \
  g++ \
  unzip \
  curl \
  git \
  xclip \
  ripgrep \
  jq \
  vim \
  neovim \
  tmux \
  bash-completion \
  wget \
  make \
  fzf \
  nodejs \
  npm \
  zoxide \
  ranger

# Set up user
ARG USERNAME=test-dev
ARG UID=1000
RUN adduser \
  -u $UID \
  -D \
  -s bash \
  -h /home/$USERNAME \
  -g "dev" \
  $USERNAME

RUN passwd -u $USERNAME \
  adduser $USERNAME wheel

RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER $USERNAME
WORKDIR /home/$USERNAME
ENV TERM xterm-256color

# Autocompletion
RUN curl -o ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

# Setting up env
ARG DOTFILES=https://github.com/ranta0/dotfiles
RUN git clone $DOTFILES ~/dotfiles \
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
RUN nvim --headless +PlugInstall +qa
RUN nvim --headless +PlugInstall +qa

CMD ["bash"]
