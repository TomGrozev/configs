#!/bin/bash

#####################################################
#                                                   #
# Init script to install ansible and start playbook #
# By @TomGrozev                                     #
#                                                   #
#####################################################

# Check if Linux or MacOS
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=linux;;
    Darwin*)    machine=mac;;
    *)          machine="UNKNOWN:${unameOut}"
esac

if [ ! "$(which ansible-playbook)" ]; then
    if [ "$machine" == "linux" ]; then
        # Get distro
        DISTRO="$(awk -F= '/^ID=/{print $2}' /etc/os-release)"
        printf "~~> You are using $DISTRO\n\n"

        # Set install command
        INSTALL_CMD=$(case "$DISTRO" in
            ("fedora") printf "dnf install -y -q" ;;
            ("debian") printf "apt install -y -qq" ;;
            ("ubuntu") printf "apt install -y -qq" ;;
            ("opensuse") printf "zypper --quiet --non-interactive install" ;;
            ("arch") printf "pacman -S --noconfirm -q" ;;
        esac)

        if [ "$INSTALL_CMD" == "" ]; then
            printf "Unknown distro $DISTRO" >&2
            exit 1
        fi

        INSTALL_CMD="sudo $INSTALL_CMD ansible"
    elif [ "$machine" == "mac" ]; then
        # Install homebrew
        command -v brew >/dev/null 2>&1 || { echo >&2 "Installing Homebrew Now"; \
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; }

        # Ensure xcode build tools are innstalled
        check=$((xcode-\select --install) 2>&1)
        echo $check
        str="xcode-select: note: install requested for command line developer tools"
        while [[ "$check" == "$str" ]];
        do
          osascript -e 'tell app "System Events" to display dialog "xcode command-line tools missing." buttons "OK" default button 1 with title "xcode command-line tools"'
          exit;
        done

        INSTALL_CMD="brew install ansible"
    fi

    echo "~~> Installing Ansible"
    $INSTALL_CMD
fi

echo "~~> Running playbook"
ansible-playbook -i ~/.local/ansible/hosts ~/.local/ansible/playbook.yml --ask-become-pass
