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

ARG BASHRC=https://raw.githubusercontent.com/ranta0/dotfiles/main/.bashrc
RUN curl -o ~/.bashrc $BASHRC

ARG TMUX_CONF=https://raw.githubusercontent.com/ranta0/dotfiles/main/.tmux.conf
RUN curl -o ~/.tmux.conf $TMUX_CONF

ARG BASH_ALIASES=https://raw.githubusercontent.com/ranta0/dotfiles/main/.bash_aliases
RUN curl -o ~/.bash_aliases $BASH_ALIASES

ARG BASH_PROFILE=https://raw.githubusercontent.com/ranta0/dotfiles/main/.bash_profile
RUN curl -o ~/.bash_profile $BASH_PROFILE

ARG VIMRC=https://raw.githubusercontent.com/ranta0/dotfiles/main/.vimrc
RUN curl -o ~/.vimrc $VIMRC

ARG GITCONFIG=https://raw.githubusercontent.com/ranta0/dotfiles/main/.gitconfig
RUN curl -o ~/.gitconfig $GITCONFIG

ARG NVIM_CONFIG=https://github.com/ranta0/nvim
RUN mkdir -p .config/nvim \
  && git clone --depth=1 $NVIM_CONFIG .config/nvim \
  && chown $USERNAME:$USERNAME .config/nvim

CMD ["bash"]
