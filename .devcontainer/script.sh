# Clone .vscode settings for debugging
git clone https://github.com/ipqa-research/vscode-fortran .vscode

# Update apt repositories
sudo apt update && sudo apt-get -y upgrade

sudo apt-get -y install \
    python3-pip python3-venv pipx \
    gfortran \
    libblas-dev liblapack-dev \
    gdb \
    fzf

# Install fortran language server, fprettify and flinter
packages=( fortls findent flinter ford fpm fypp )
for package in ${packages[@]}; do
    pipx install $package --force --pip-args=--pre
done
