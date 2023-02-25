#!/bin/bash

pushd .

cd $(mktemp -d)

# Install if needed
if ! [ command -v nvim &> /dev/null ]; then
    URL="https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"
    if test -n "$NEOVIM_VERSION"
    then
        URL="https://github.com/neovim/neovim/releases/download/$NEOVIM_VERSION/nvim.appimage"
    fi

    # Install
    curl -LO "$URL"
    chmod u+x nvim.appimage
    ./nvim.appimage --appimage-extract >/dev/null
    mkdir -p /home/gitpod/.local/bin
    ln -s $(pwd)/squashfs-root/AppRun /home/gitpod/.local/bin/nvim
fi

# Setup config if needed
if ! [ test -f "~/.config/nvim/init.lua" ]; then
    # Setup environment
    CONIG_REPO="https://github.com/WilSimpson/kickstart.nvim.git"
    if test -n "$NEOVIM_CONFIG_REPO"
    then
        CONFIG_REPO="$NEOVIM_CONFIG_REPO"
    fi

    git clone $CONIG_REPO ~/.config/nvim

    nvim --headless "+Lazy! sync" +qa
fi
