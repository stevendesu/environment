# Steven's Wonderful Terminal Environment

## Table of Contents

 - [What even is this?](#what-even-is-this)
 - [Dependencies](#dependencies)
 - [Features](#features)
 - [How to install it?](#how-to-install-it)
 - [Z Shell](#z-shell)
 - [Terminal Multiplexer](#terminal-multiplexer)
 - [NeoVim](#neovim)

## What even is this?

This repository stores setup scripts and configurations for my preferred
working environment. Using this you can configure your shell to look and
behave the way mine does.

Is this strictly necessary? Not really. But it's really cool. I can almost
guarantee that developers will find themselves working twice as fast (at
least) if they adopt my environment!

## Dependencies

For starters, my coding environment utilizes the
[Z Shell](http://zsh.sourceforge.net/) as opposed to the Bourne Shell, the
Bourn Again Shell (Bash), Korn Shell (ksh), or any other alternatives. I liked
this shell particularly because it has:

 - Programmable tab-completion
 - Shared command history among running shells
 - Spelling correction
 - Themeable prompts
 - Named directories

On top of the Z Shell I utilize a
[Terminal Multiplexer](https://github.com/tmux/tmux/wiki) to work in parallel
and handle long-running background tasks. For this I chose tmux because of its
popularity and the following features that I take advantage of:

 - A programmable status line
 - Vertical and horizontal window splitting
 - The ability to link windows to multiple sessions

Finally, as a text editor of choice, I went with [NeoVim](https://neovim.io/)
due to:

 - Multi-threaded plugins and asychronous job control (it's faster)
 - Identical interface to vi, which is installed almost everywhere
 - Compatibility with vi plugins

## Features

For configurations specific to any one component of the environment, jump to
the component's section below.

Upon installing my environment, you will be graced with the following benefits
in your day to day life:

 - Ability to close and re-open your Terminal app without losing any work.
   Pick up right where you left off!
 - Responsive status bar which shows more information as you expand the size
   of your Terminal app. Depending on screen size, this displays any of:
     - Currently logged in user name
	 - Current machine host name
	 - Current machine IP address
	 - Current machine Operating System
	 - Current machine uptime
	 - Screen size
	 - Currently active tmux window
	 - Currently running program
	 - CPU utilization
	 - RAM utilization
	 - Whether an HTTP server is running on the current machine
	 - The current time
 - Ability to work in parallel by creating split windows
 - Line numbers and code linters
 - etc.

Beyond that, it also installs several useful development tools for you:

 - [cURL](https://curl.haxx.se/) for making HTTP requests
 - [NodeJS](https://nodejs.org/en/) for JavaScript development
 - [NPM](https://www.npmjs.com/) the JavaScript package manager
 - [Python](https://www.python.org/) for Python development
 - [PIP](https://pypi.org/project/pip/) the Python package manager
 - [eslint](https://eslint.org/) a JavaScript code linter
 - [pylint](https://www.pylint.org/) a Python code linter
 - [flake8](https://pypi.org/project/flake8/) a Python code style checker
 - [bandit](https://pypi.org/project/bandit/) a Python security linter

## How to install it?

In order to install this environment, you first need to install git. How you
do this is different on every machine, so try Googling it.

Once git is installed, set up the environment like so:

```
# Go to your home directory:
cd ~

# Clone the repository:
git clone https://github.com/stevendesu/environment.git

# Go to the environment directory:
cd environment

# Run the setup script
./setup.sh
```

That should be it! The script currently works on Ubuntu and Mac OS X, and may
work on other machines (untested). I will work on adding support for more as
the need arises.

## Z Shell

To configure the Z Shell I utilized
[Prezto](https://github.com/sorin-ionescu/prezto), a fork of Oh-My-ZSH focused
on performance. Prezto is a framework for configuring ZSH which provides sane
defaults, alises, additional auto completions, and several prompt themes.

I forked Prezto to create my own `stevendesu` theme. This theme:

 - Displays the current time when a prompt is displayed (effectively making it
   easy to tell when a command finished running)
 - Displays a shortened version of the current directory (e.g.
   `/home/stevendesu/code/project1/src/components/` will be displayed as
   `~/c/p/s/components`)
 - Displays the current git branch, if any
 - Displays whether or not the current git workspace is clean
 - Utilizes only ASCII characters for support on machines without Unicode
 - Uses ANSI colors to make it easier to read

Furthermore I added a few additional aliases:

 - `python` -> `python3`
 - `pip` -> `pip3`
 - `vi` -> `nvim`
 - `vim` -> `nvim`

Finally, I created several useful tools that can be run from the command-line:

 - `weather` will display the weather in your local region
 - More to come

## Terminal Multiplexer

For tmux I created a custom `.tmux.conf` file:

 - Enables support for 256 colors (if the machine allows for it)
 - Increases the scrollback history to 100,000 lines (per pane)
 - Enables vi-style key bindings for copy/paste
 - Allows the use of `|` and `-` to perform vertical and horizontal splits
 - Allows both vi-style key bindings and arrow keys to switch panes
 - Allows the use of the mouse to select panes, scroll through history, and
   to select text for copy/paste
 - Leave tmux sessions alive indefinitely until killed manually
 - Display custom status bar text (`left.sh` and `right.sh`)

Furthermore, running `setup.sh` will add one additional line to the tmux
configuration file based on your operating system. This line will cause the
copy/paste function in tmux to also copy to the operating system's clipboard
buffer, so you can easily paste into graphical programs

## NeoVim

For NeoVim I take advantage of several plugins:

 - [NerdTree](https://github.com/scrooloose/nerdtree)
 - [Syntastic](https://github.com/vim-syntastic/syntastic)
 - [vim-trailing-whitespace](https://github.com/bronson/vim-trailing-whitespace)
 - [vim-javascript](https://github.com/pangloss/vim-javascript)
 - [Neomake](https://github.com/neomake/neomake)

I utilize the [monokai](https://github.com/sickill/vim-monokai) color theme

Beyond this, I have an `init.vim` configuration file which heavily modifies
the default behavior in many cases:

 - Backspace will back over end of line to previous line
 - The clipboard register is sync'd with the system clipboard, allowing for
   copy/paste between nvim and graphical programs
 - A vertical ruler displays the 80-character and 120-character columns
 - Line numbers are displayed
 - Searches are case insensitive
 - Syntax highlighting is enabled (whenever possible)
 - `.vue` files are treated as HTML for syntax highlighting
 - Backups of open files, buffers, and pointer data are stored to
   `~/.config/nvim` instead of the default behavior where they are located in
   the same directory as the file you're working on (avoids accidentally
   committing temporary cache files)
 - "Undo" history is retained between instances, so you can close nvim, reopen
   it, and undo changes you made last time it was open
 - Support for UTF-8 encoded files
 - Automatic correction for several typos when working too quickly (e.g. `W!`
   is corrected to `w!`, or `qw` is corrected to `wq`)
 - Remembers cursors position between sessions (you can close nvim, reopen it,
   and you'll be in the same part of the file you were in last time)
 - HTML, JavaScript, Python, and C++ files are automatically checked with code
   linters every time you save the file. I *think* I also added support for
   Rust, but can't remember
