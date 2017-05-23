###############################################################################
# New Server Setup Script
# -----------------------
#
# This script was created to try and standardize my working environment
# whenever I start working with a new server or PC.
#
# You may notice the lack of a shebang (#!) line at the beginning. This was
# done to maintain compatibility across the widest range of operating systems.
# While #!/bin/sh will work on any BSD or GNU/Lnux OS, it doesn't work on
# Android-based operating systems and wouldn't run on a Chromebook. By leaving
# it off I leave it up to the operating system to determine how best to run
# this script.
#
# The script is sh-compatible, so it should work in almost any shell.
# Support for csh and tcsh just wasn't a priority. Maybe later.
#
# Out of an abundance of caution and for compatibility on all displays, this
# script should never exceed 79 characters in width (the length of the first
# line).
#
# Usage: ./setup.sh
#
# Note: All of that compatibility shit I was talking about? I don't have
# any of it yet. That's all idealism. For simplicity I'm starting with a script
# that works for me (runs on Ubuntu 16.04) and I'll tweak it as I encounter
# issues. That means I'm assuming Debian with apt and every other thing to make
# life easy. I'll also assume I am running as a non-root user in the sudoers
###############################################################################

# Step 1: Determine if we have sudo power. This will determine how we install
#         different software going forward

# Step : Ensure our submodules are initialized
echo "Preparing environment repo..."
git submodule update --init --recursive

# Step : Install zsh
echo "Installing zsh..."
sudo apt-get --yes install zsh > /dev/null

# Step : Configure zsh
echo "Configuring zsh..."
# Requires a password (may require root?):
chsh -s $(which zsh)
#echo "export SHELL=\`which zsh\`" >> ~/.profile
#echo "[ -z \"\$ZSH_VERSION\" ] && exec \"\$SHELL\" -l" >> ~/.profile

# Step : Install tmux
echo "Installing tmux..."
sudo apt-get --yes install tmux > /dev/null

# Step : Install neovim
echo "Installing neovim..."
#sudo apt-get --yes install software-properties-common > /dev/null
#sudo apt-add-repository -y ppa:neovim-ppa/unstable > /dev/null
#sudo apt-get update > /dev/null
#sudo apt-get --yes install neovim > /dev/null
sudo apt-get install neovim
sudo apt-get install python-neovim
sudo apt-get install python3-neovim

# Step : Configure neovim
echo "Configuring neovim..."
#sudo apt-get --yes install python-dev python-pip python3-dev \
#	python3-pip > /dev/null
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60 > /dev/null
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim \
	60 > /dev/null
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim \
	60 > /dev/null

# Step : Copy config and rc files
ln -s ./.tmux.d ~/
ln -s ./.tmux.conf ~/
ln -s ./.zlogin ~/
ln -s ./.zlogout ~/
ln -s ./.zpreztorc ~/
ln -s ./.zshenv ~/
ln -s ./.zshrc ~/
mkdir ~/.config/nvim
ln -s ./init.vim ~/.config/nvim/

# Step : Run vim setup
vim +PlugInstall +qall
