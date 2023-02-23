#!/bin/bash

# clone repo into ~/
git clone git@github.com:ericpaulsen/dot-v2.git

# Add GitHub as a known host
echo "adding GitHub as a known host"
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

# Install starship.rs
echo "installing starship"
# Install Starship
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -y -f

# Install fonts
cp ~/dot-v2/fonts /usr/share/fonts

echo "installing extensions..."
# Install extensions & set VSCode prefs
code-server --install-extension streetsidesoftware.code-spell-checker
code-server --install-extension HashiCorp.terraform
code-server --install-extension ms-azuretools.vscode-docker
code-server --install-extension golang.Go
cp -f ~/dotfiles/settings.json /home/coder/.local/share/code-server/User/settings.json

# Install fish & make it default shell
echo "installing fish shell"
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt-get install -y fish

echo "copying fish & starship config"
cp -f ~/dot-v2/.config/fish/config.fish ~/.config/fish/config.fish
cp -f ~/dot-v2/.config/starship.toml ~/.config/starship.toml

echo "changing shell"
sudo chsh -s /usr/bin/fish $USER

# Install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

# Install kubecolor
if type go; then
    echo "installing kubecolor..."
    go install github.com/hidetatz/kubecolor/cmd/kubecolor@latest
fi

# Install kubectx
echo "installing kubectx"
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens