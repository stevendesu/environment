###############################################################################
# New Server Setup Script
# -----------------------
#
# This script was created to try and standardize my working environment
# whenever I start working with a new server or PC.
#
# The script is sh-compatible, so it should work in almost any shell.
#
# Usage: ./setup.sh
###############################################################################

SOURCE="$0"
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

# Step 1: Determine if we have sudo power. This will determine how we install
#         different software going forward
# TODO: Update this based on sudo ability
SUDO="sudo"

# Step 2: Ensure our submodules are initialized
echo "Preparing environment repo..."
git submodule update --init --recursive > /dev/null

# Step 3: Install a package manager
echo "Installing package manager..."
INSTALL=""
if [[ "$OSTYPE" = linux* ]]; then
  # TODO: Detect if we have access to apt-get, yum, etc
  echo "TODO"
  INSTALL="$SUDO apt-get install --yes"
elif [[ "$OSTYPE" = darwin* ]]; then
  brew --version || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" > /dev/null
  INSTALL="brew install"
fi

# Step 3: Install zsh
echo "Installing zsh..."
INSTALL zsh > /dev/null

# Step 4: Configure zsh
echo "Configuring zsh..."
# Requires a password (may require root?):
chsh -s $(which zsh)
#echo "export SHELL=\`which zsh\`" >> ~/.profile
#echo "[ -z \"\$ZSH_VERSION\" ] && exec \"\$SHELL\" -l" >> ~/.profile

# Step 5: Install tmux
echo "Installing tmux..."
INSTALL tmux > /dev/null

# Step 6: Install other development tools
echo "Installing dev tools..."
INSTALL curl > /dev/null
INSTALL nodejs > /dev/null
INSTALL npm > /dev/null
INSTALL python3 > /dev/null
curl https://bootstrap.pypa.io/get-pip.py | python3

# Step 7: Install neovim (after Python3)
echo "Installing neovim..."
#sudo apt-get --yes install software-properties-common > /dev/null
#sudo apt-add-repository -y ppa:neovim-ppa/unstable > /dev/null
#sudo apt-get update > /dev/null
INSTALL neovim > /dev/null
INSTALL python-neovim > /dev/null
INSTALL python3-neovim > /dev/null

# Step 8: Install linters
echo "Installing linters..."
npm install -g eslint eslint-plugin-vue eslint-plugin-cypress  > /dev/null
pip install --user pylint flake8 bandit > /dev/null

# Step 9: Copy config and rc files
echo "Copying config files to ${DIR}..."
ln -s ${DIR}/.tmux.d ~/
# tmux conf must be adjusted per platform
#ln -s ${DIR}/.tmux.conf
cp ${DIR}/.tmux.conf ~/
ln -s ${DIR}/.zlogin ~/
ln -s ${DIR}/.zlogout ~/
ln -s ${DIR}/.zprezto ~/
ln -s ${DIR}/.zpreztorc ~/
ln -s ${DIR}/.zshenv ~/
ln -s ${DIR}/.zshrc ~/
# Certain programs or scripts may modify .zprofile
# I don't want those changes to persist as part of my "base" environment
#ln -s ${DIR}/.zprofile ~/
cp ${DIR}/.zprofile ~/
mkdir -p ~/.config/nvim/autoload
mkdir -p ~/.config/nvim/colors
ln -s ${DIR}/init.vim ~/.config/nvim/
ln -s ${DIR}/vim-plug/plug.vim ~/.config/nvim/autoload/
ln -s ${DIR}/vim-monokai/colors/monokai.vim ~/.config/nvim/colors/
ln -s ${DIR}/.eslintrc ~/

# Step 10: Update tmux conf
echo "\n\n# Enable copy/paste from tmux to GUI" >> ~/.tmux.conf
if [[ "$OSTYPE" = linux* ]]; then
  echo "bind -T copy-mode-vi y send-keys -X copy-pipe \"xclip -sel clip -i > /dev/null\"" >> ~/.tmux.conf
elif [[ "$OSTYPE" = darwin* ]]; then
  echo "bind -T copy-mode-vi y send-keys -X copy-pipe \"pbcopy\"" >> ~/.tmux.conf
fi

# Step 11: Run vim setup
echo "Running vim setup..."
vim +PlugInstall +qall
