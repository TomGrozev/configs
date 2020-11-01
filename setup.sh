## Any setup commands on new system

# Get distro
DISTRO="$(awk -F= '/^ID/{print $2}' /etc/os-release)"

# Set install command
INSTALL_CMD=""
[ "$DISTRO" == "fedora" ] && INSTALL_CMD="dnf install" || :
[ "$DISTRO" == "debian" ] && INSTALL_CMD="apt install" || :
[ "$INSTALL_CMD" == "" ] && (echo "Unknown distro $DISTRO" >&2; exit 1) || :

echo "You are using $DISTRO"

INSTALL_CMD="sudo $INSTALL_CMD"

# Install some useful packages
PACKAGES="zsh thefuck autojump bat curl"

echo "~~> Installing packages"
$INSTALL_CMD $PACKAGES

# Set ZSH as shell
chsh -s /bin/zsh $USER

# Clear font cache
fc-cache -fv

# Install submodules
git submodule init
git submodule update

# Install themes
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
