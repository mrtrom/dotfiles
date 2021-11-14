#!/usr/bin bash

# Install zsh
echo -e "Installing zsh\n"
if command -v zsh &> /dev/null && command -v git &> /dev/null && command -v wget &> /dev/null; then
    echo -e "ZSH and Git are already installed\n"
else
    if sudo apt install -y zsh git wget || sudo pacman -S zsh git wget || sudo dnf install -y zsh git wget || sudo yum install -y zsh git wget || sudo brew install git zsh wget || pkg install git zsh wget ; then
        echo -e "zsh wget and git Installed\n"
    else
        echo -e "Please install the following packages first, then try again: zsh git wget \n" && exit
    fi
fi

# Backup .zshrc
# if mv -n ~/.zshrc ~/.zshrc-backup-$(date +"%Y-%m-%d"); then
#     echo -e "Backed up the current .zshrc to .zshrc-backup-date\n"
# fi

# Installing fonts

if command --version fc-cache &> /dev/null; then
    echo -e "fontconfig already installed\n"
else
    if brew install fontconfig ; then
        echo -e "contconfig Installed\n"
    else
        echo -e "Please install the following packages first, then try again: fontconfig \n" && exit
    fi
fi

echo -e "Installing Nerd Fonts version of Hack, Roboto Mono, DejaVu Sans Mono\n"
wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf -P ~/.fonts/
wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/RobotoMono/Regular/complete/Roboto%20Mono%20Nerd%20Font%20Complete.ttf -P ~/.fonts/
wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete.ttf -P ~/.fonts/

fc-cache -fv ~/.fonts

# Install zplug
$ curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

# Install fzf
if [ -d ~/.fzf ]; then
    cd ~/.fzf && git pull
    ~/.fzf/install --all --key-bindings --completion --no-update-rc
else
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --key-bindings --completion --no-update-rc
fi

# Install Starship
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -f

# Install fnm (node version manager)
if command --version fnm &> /dev/null; then
    echo -e "fnm already installed\n"
else
    if brew install fnm ; then
        echo -e "fnm Installed\n"
    else
        echo -e "Please install the following packages manually: fnm \n" && exit
    fi
fi