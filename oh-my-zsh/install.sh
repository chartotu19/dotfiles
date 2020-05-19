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
