#!/bin/bash

# Packages to install
PACKAGES="python3 python3-pip python3-setuptools xclip zsh neovim thefuck autojump bat curl gcc make cmake autoconf automake python3-docutils nodejs npm golang default-jdk"
DNF_PACKAGES="$PACKAGES python3-devel pkgconfig libseccomp-devel jansson-devel libyaml-devel libxml2-devel gcc-c++"
DEBIAN_PACKAGES="$PACKAGES python3-dev pkg-config libseccomp-dev libjansson-dev libyaml-dev libxml2-dev build-essential"

## Any setup commands on new system

# Get distro
DISTRO="$(awk -F= '/^ID=/{print $2}' /etc/os-release)"
printf "You are using $DISTRO\n\n"

# Set install command
INSTALL_CMD=$(case "$DISTRO" in
    ("fedora") printf "dnf install -y $DNF_PACKAGES" ;;
    ("debian") printf "apt install -y $DEBIAN_PACKAGES" ;;
    ("ubuntu") printf "apt install -y $DEBIAN_PACKAGES" ;;
esac)

if [ "$INSTALL_CMD" == "" ]; then
    printf "Unknown distro $DISTRO" >&2
    exit 1
fi

INSTALL_CMD="sudo $INSTALL_CMD"

# Install some useful packages
printf "~~> Installing packages\n"
$INSTALL_CMD
printf "Packages installed\n\n"

printf "\n\n"

# Make sure in home dir
cd $HOME

# Set ZSH as shell
printf "~~> Setting ZSH as default shell\n"
if [ "$SHELL" == "/bin/zsh" ]; then
    printf "ZSH is already the default shell, yay!"
else
    chsh -s /bin/zsh $USER
fi

printf "\n\n"

# Clear font cache
printf "~~> Installing fonts\n"
fc-cache -fv &> /dev/null
printf "Fonts installed\n\n"

# Install ctags
if [[ -f "/usr/local/bin/ctags" ]]; then
    printf "[[ Ctags already installed ]]\n"
else
    printf "~~> Installing Ctags\n"
    git clone https://github.com/universal-ctags/ctags /tmp/ctags &> /dev/null
    cd /tmp/ctags
    sh ./autogen.sh &> /dev/null
    sh ./configure --prefix=/usr/local &> /dev/null
    make &> /dev/null
    sudo make install &> /dev/null
    rm -rf /tmp/ctags
    cd $HOME
    printf "Ctags installed\n\n"
fi

# Install submodules
printf "~~> Installing Modules\n"
git submodule init
git submodule update
printf "Modules Installed\n\n"

# Install themes
if [[ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
    printf "[[ Themes already installed ]]\n"
else
    printf "~~> Installing Themes\n"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k &> /dev/null
    printf "Themes installed\n\n"
fi

# Install plugins
printf "~~> Installing Shell Plugins\n"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting &> /dev/null
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions &> /dev/null
printf "Shell Plugins installed\n\n"

# Update vim plugins
printf "~~> Installing Vim Plugins\n"
python3 $HOME/.vim_runtime/update_plugins.py
printf "Vim Plugins installed\n\n"

# Setup youcompleteme
printf "~~> Installing YouCompleteMe\n"
python3 $HOME/.vim_runtime/plugins/YouCompleteMe/install.py --go-completer --java-completer --quiet
printf "YouCompleteMe installed\n\n"

# Setup git environment
read -p "Setup git? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    printf "\n~~> Seting git environment\n"
    read -p "Enter your name: " git_name
    read -p "Enter your email: " git_email

    git config --global user.name $git_name
    git config --global user.email $git_email

    git config --global color.ui true
    git config --global core.editor nvim

    printf "Your git config is:\n"
    git config --list
fi

printf "\n\n"

# Setup SSH
read -p "Setup SSH Keys? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    printf "\n~~> Setting up SSH\n"

    SSH_KEY_PATH="$HOME/.ssh"
    if [ -e $SSH_KEY_PATH/id_rsa.pub ]; then
        printf "Already have an SSH key, using that.\n"
    else
        ssh-keygen -t rsa -b 4096 -C $git_email
    fi

    eval "$(ssh-agent -s)"
    ssh-add $SSH_KEY_PATH/id_rsa

    xclip -selection clipboard < $SSH_KEY_PATH/id_rsa.pub
    printf "Public SSH Key copied to clipboard. Add it to github here is how: https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account.\n"
fi

printf "\n\n"


# Setup Jetbrains
read -p "Setup Jetbrains Toolbox? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    printf "\n~~> Setting Jetbrains toolbox\n"

    read -p "Where to install Jetbrains? (e.g. /opt/jetbrains)? " toolbox_path
    toolbox_path=${toolbox_path:-/opt/jetbrains}

    if [ ! "$(ls -A ${HOME}/.local/share/JetBrains/Toolbox 2> /dev/null)" ]; then
        printf "Installing JetBrains Toolbox"

        TOOLBOX_URL=$(curl --silent 'https://data.services.jetbrains.com//products/releases?code=TBA&latest=true&type=release' \
        -H 'Origin: https://www.jetbrains.com' \
        -H 'Accept-Encoding: gzip, deflate, br' \
        -H 'Accept-Language: en-US,en;q=0.8' \
        -H 'Accept: application/json, text/javascript, */*; q=0.01' \
        -H 'Referer: https://www.jetbrains.com/toolbox/download/' \
        -H 'Connection: keep-alive' \
        -H 'DNT: 1' \
        --compressed \
      | grep -Po '"linux":.*?[^\\]",' \
      | awk -F ':' '{print $3,":"$4}'| sed 's/[", ]//g')

        install -d ${HOME}/bin
        curl -sL ${TOOLBOX_URL} | tar xvz --directory=${HOME}/bin --strip-components=1

        $(jetbrains-toolbox)
    fi

    #mkdir -p $toolbox_path/toolbox
    sudo mkdir -p $toolbox_path/lib
    sudo mkdir -p $toolbox_path/bin

    #if [ ! "$(ls -A $toolbox_path/toolbox)" ]; then
    #    cp -r ${HOME}/.local/share/JetBrains/Toolbox $toolbox_path/toolbox
    #    rm -rf ${HOME}/.local/share/JetBrains/Toolbox
    #    ln -s $toolbox_path/toolbox ${HOME}/.local/share/JetBrains/Toolbox
    #fi

    printf "Set install location to '$toolbox_path/lib' and the shell scripts location to '$toolbox_path/bin'"

fi

printf "\n\n"

printf "~> Language specifics\n"

# Setup ELixir Environment
read -p "Setup Elixir Environment? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    printf "\n~~> Setting up Elixir Environment\n"
    # Check if elixir already installed
    if ! command -v elixir &> /dev/null; then
        # Install elixir
        function debian_elixir_install {
            wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb -P /tmp/ && sudo dpkg -i /tmp/erlang-solutions_2.0_all.deb
            rm /tmp/erlang-solutions_2.0_all.deb
            sudo apt-get update
            sudo apt-get install esl-erlang
            sudo apt-get install elixir
        }

        case "$DISTRO" in
            ("fedora") sudo dnf install -y elixir ;;
            ("debian") debian_elixir_install ;;
            ("ubuntu") debian_elixir_install  ;;
        esac
    fi

    # Install Hex
    mix local.hex

    # Setup Phoenix
    mix archive.install hex phx_new

    # Setup Elixir LS
    git clone https://github.com/elixir-lsp/elixir-ls $HOME/.local/share/elixir-ls &> /dev/null
    cd $HOME/.local/share/elixir-ls
    mix deps.get
    mix compile
    MIX_ENV=prod mix elixir_ls.release
    cd $HOME

    printf "Elixir Environment setup\n\n"
fi

printf "\n\n"

printf "All done :D\n"
