#!/usr/bin/env bash

# we create storage per region since it has to be aligned since most native VM has only 500GB
# on the VM, put persistent data on the storage such as code, key model data (are they charged? yes)
# put miniforge/conda at home (this will be wiped out every shutdown) good to have automation!

# testcases
# fresh VM, fresh disk
# fresh VM, old disk (restart case, or other type of instance with more hardware) virginia

cd ~
cat << 'EOF' >> ~/.bashrc
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] : \[\033[01;34m\]\w\[\033[01;31m\]$(__git_ps1)\[\033[00m\]\n$ '
EOF
echo "source ~/vs-bashutil/bash_functions.sh" >> ~/.bashrc
echo "source ~/vs-bashutil/host_vars.sh" >> ~/.bashrc 
echo "export WORKDIR=~/work" >> ~/.bashrc
source ~/.bashrc

# collect all directories in cwd whose names start with drive-
DRIVES=( $(ls -d drive-* 2>/dev/null) )

if (( ${#DRIVES[@]} == 0 )); then
  echo "Error: no directory starting with 'drive-'" >&2
  exit 1
elif (( ${#DRIVES[@]} > 1 )); then
  echo "Error: multiple directories starting with 'drive-':" >&2
  printf "  %s\n" "${DRIVES[@]}" >&2
  exit 1
fi

# link the first drive directory to ~/work (WORKDIR)
DISKPATH=$(realpath ${DRIVES[0]})
ln -sv $DISKPATH $WORKDIR

# install miniforge at ~/
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh -b && rm -f Miniforge3-$(uname)-$(uname -m).sh
INSTALL_DIR=$(realpath ~/miniforge3)
$INSTALL_DIR/bin/conda init bash

# set up Huggingface home, dev, run area
nw-dir $WORKDIR/huggingface
nw-dir $WORKDIR/dev
nw-dir $WORKDIR/run
# echo "export HF_HOME=$WORKDIR/huggingface" >> ~/.bashrc # redundant, already set in host_vars.sh

# install vscode via snap
# sudo snap install --classic code #because we usually open with vscode, the code is installed upon we enter the server via vscode, so we comment this out
code --install-extension ms-python.python

git config --global credential.helper store
git config --global user.email "vuiseng9@gmail.com"
git config --global user.name "Vui Seng Chua"

set-pacific-timezone

# Example usage
# cd ~/work/dev
# nw-conda-env
# envname=lmb-ca-a10-$(datestr)-rblx-voice
# nw-conda-env $envname 3.12
# mkdir -p ~/work/dev/${envname} if this doesnt get created automatically
# act $envname

# huggingface login
# test drive

