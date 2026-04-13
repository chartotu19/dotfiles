#!/bin/bash
OH_MY_ZSH=$HOME/.oh-my-zsh
ZSH_CUSTOM=$OH_MY_ZSH/custom

if [ ! -d "$OH_MY_ZSH" ] ; then
    git clone https://github.com/ohmyzsh/ohmyzsh.git $OH_MY_ZSH
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] ; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] ; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi

if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ] ; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
fi

# Install Nerd Fonts for Powerlevel10k icons
if [ "$(uname -s)" == "Darwin" ] ; then
    if ! brew list --cask font-meslo-lg-nerd-font &> /dev/null ; then
        brew install --cask font-meslo-lg-nerd-font
    fi
elif [ "$(uname -s)" == "Linux" ] ; then
    FONT_DIR="$HOME/.local/share/fonts"
    if [ ! -f "$FONT_DIR/MesloLGSNerdFont-Regular.ttf" ] ; then
        mkdir -p "$FONT_DIR"
        curl -fLo "$FONT_DIR/MesloLGSNerdFont-Regular.ttf" https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/Meslo/S/Regular/MesloLGSNerdFont-Regular.ttf
        curl -fLo "$FONT_DIR/MesloLGSNerdFont-Bold.ttf" https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/Meslo/S/Bold/MesloLGSNerdFont-Bold.ttf
        curl -fLo "$FONT_DIR/MesloLGSNerdFont-Italic.ttf" https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/Meslo/S/Italic/MesloLGSNerdFont-Italic.ttf
        curl -fLo "$FONT_DIR/MesloLGSNerdFont-BoldItalic.ttf" https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/Meslo/S/BoldItalic/MesloLGSNerdFont-BoldItalic.ttf
        fc-cache -fv
    fi
fi
