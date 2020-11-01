#!/bin/bash

## Any setup commands on new system

# Get distro
DISTRO="$(awk -F= '/^ID/{print $2}' /etc/os-release)"

# Set install command
INSTALL_CMD=$(case "$DISTRO" in
    ("fedora") printf "dnf install" ;;
    ("debian") printf "apt install" ;;
esac)

if [ "$INSTALL_CMD" == "" ]; then
    printf "Unknown distro $DISTRO" >&2
    exit 1
fi

printf "You are using $DISTRO\n\n"

INSTALL_CMD="sudo $INSTALL_CMD"

# Install some useful packages
PACKAGES="python3 python3-pip python3-dev python3-setuptools xclip zsh neovim thefuck autojump bat curl"

printf "~~> Installing packages\n"
$INSTALL_CMD $PACKAGES

printf "\n\n"

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

# Install submodules
printf "~~> Installing Modules\n"
git submodule init
git submodule update
printf "Modules Installed\n\n"

# Install themes
printf "~~> Installing Themes\n"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k &> /dev/null
printf "Themes installed\n\n"

# Install plugins
printf "~~> Installing Plugins\n"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting &> /dev/null
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions &> /dev/null
printf "Plugins installed\n\n"


# Setup git environment
read -p "Setup git? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    printf "~~> Seting git environment\n"
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
    printf "~~> Setting up SSH\n"

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

printf "All done :D\n"
