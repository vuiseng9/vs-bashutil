#!/usr/bin/env bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# printf with newline
printfn() {
    printf "$@\n"
}

datestr() {
    date +"%y%m%d"
}

set-pacific-time() {
    # Set the timezone to Los Angeles (Pacific Time)
    export TZ="America/Los_Angeles"
    sudo timedatectl set-timezone "$TZ"
}

ls-funcs() {
    declare -F | grep -v _
    # copy the line from the printout to see the function definition
    # or type <func>
}

#= File/Folder Management ==================================================
# df -h # drive usage
# du -sh <path> #disk usage of path
fover10() {
	find . -type f -size +10M | xargs du -sh
}

nw-dir() {
    local dir="$1"
    # Quit early if no argument given
    [[ -z "$dir" ]] && { echo "Usage: ${FUNCNAME[0]} <directory>" >&2; return 1; }

    # If the path already exists as a directory, do nothing.
    # Otherwise, create it (with parents) and report what happened.
    if [[ -d "$dir" ]]; then
        echo "$dir exists." && return 0
    else
        mkdir -p -- "$dir" && echo "Created directory: $dir"
    fi
}
#= GPU UTIL ================================================================
ns() {
    nvidia-smi $@
}

rs() {
    rocm-smi $@
}

amds() {
    amd-smi static -a -v
}

ns1() {
    nvidia-smi -l 1
}

as1() {
    watch -n 1 amd-smi monitor
}

nvdev() {
    if [ -z ${CUDA_VISIBLE_DEVICES} ]; then
        printfn "[Info]: CUDA_VISIBLE_DEVICES is not set"
    else
        printfn "[Info]: CUDA_VISIBLE_DEVICES = ${GREEN}${CUDA_VISIBLE_DEVICES}${NC}"
    fi    
}

install-torch() {
    # Uninstall existing torch packages if any
    pip uninstall -y torch torchvision torchaudio

    # Install torch with CUDA support
    if [ -z "$1" ]; then
        echo "Usage: install-torch <cuda_version, e.g. 126>"
        return 1
    fi

    local cuda_version="$1"
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu${cuda_version}

    # Verify installation, print the installed versions using pip freeze
    pip freeze | grep -E 'torch|torchvision|torchaudio' | while read -r line; do
        echo "Installed: $line"
    done
}

install-cuda-toolkit-conda() {
    # Install the CUDA toolkit using conda
    if [ -z "$1" ]; then
        echo "Usage: install-cuda-toolkit-conda <cuda_version, e.g. 12.6>"
        return 1
    fi

    local cuda_version="$1"
    conda install -c nvidia cuda-toolkit=$cuda_version -y

    # Verify installation, print the installed versions using conda list
    conda list | grep cuda
}

#= CONDA ===================================================================
ls-conda-env() {
    conda info --envs
}

act() {
    if [ ! -d $1 ]
    then
        # printfn "Folder doesn't exist."
        conda activate $1
    else
        # this functionality assumes dirname is also an existing conda env
        # act .
        fullpath=$(realpath $1)
        dir=$(basename $fullpath)
        conda activate $dir
    fi
}

deact() {
    conda deactivate $1
}

nw-conda-env() {
    # e.g. create-conda some_env 3.11
    conda create -n $1 python=$2 -y
    if ! [ -z $VS_DEV_DIR ]; then
        ENVDIR=$VS_DEV_DIR/$1
        mkdir -p $ENVDIR
        if [ -d $ENVDIR ]; then
            printfn "[Info]: Created, cd-ed and activated ${GREEN}${ENVDIR}${NC}."
            cd $ENVDIR
            act $1
        fi
    fi    
}

rm-conda-env() {
    deact
    conda remove --name $1 --all -y
    if ! [ -z $VS_DEV_DIR ]; then
        ENVDIR=$VS_DEV_DIR/$1
        if [ -d $ENVDIR ]; then
            printfn "[Reminder]: you might want to remove ${RED}${VS_DEV_DIR}/${1}${NC} folder"
        fi
    fi    
}

print-site_packages-path() {
    python -c "import site; print(site.getsitepackages()[0])"
}
#= GIT =====================================================================
gs() {
    git status $@
}

gr() {
    git remote -v
}

gc() {
    local repo="$1"
    local branch="${2}"

    # Quit early if no argument given
    [[ -z "$repo" ]] && { echo "Usage: ${FUNCNAME[0]} <repository-url> <branch>" >&2; return 1; }

    # If the repository already exists, do nothing.
    # Otherwise, clone it and report what happened.
    if [[ -d "${repo##*/}" ]]; then
        echo "${repo##*/} already exists." && return 0
    else
        # If a branch is specified, clone that branch; otherwise, clone the default branch.
        if [[ -n "$branch" ]]; then
            git clone --branch "$branch" --single-branch -- "$repo" && echo "Cloned repository: $repo (branch: $branch)"
        else
            git clone -- "$repo" && echo "Cloned repository: $repo (default branch)"
        fi
    fi
}

#= docker ====================================================================
function ls-docker {
    local sudo_cmd=""
    [[ $EUID -ne 0 ]] && sudo_cmd="sudo"

    $sudo_cmd docker ps --format "{{.ID}} | {{.Image}} | {{.Names}} | {{.Status}}"
    get-latest-docker
}

function docker-terminal {
    local sudo_cmd=""
    [[ $EUID -ne 0 ]] && sudo_cmd="sudo"

    $sudo_cmd docker exec -it $1 bash
}

function get-latest-docker {
    local sudo_cmd=""
    [[ $EUID -ne 0 ]] && sudo_cmd="sudo"

    export latest_docker=$($sudo_cmd docker ps -n=-1 --format "{{.ID}}")
}

function dt {
    docker-terminal $latest_docker
}

#= TMUX ====================================================================
ls-tmux() {
	tmux ls
}

nw-tmux() {
    if [ -z "$1" ]; then
        printfn "${RED}Error:${NC} You must provide a name for the tmux session."
        return 1
    fi
    tmux new -s $(datestr)_${1}
}

at-tmux() {
    if [ -z "$1" ]; then
        printfn "${RED}Error:${NC} You must provide a name for the tmux attach."
        ls-tmux
        return 1
    fi
    tmux a -t ${1}
}

rm-tmux() {
    if [ -z "$1" ]; then
        printfn "${RED}Error:${NC} You must provide a name for the tmux session to kill."
        return 1
    fi
    tmux kill-session -t ${1}
}

#= vscode===================================================================
# set workspace color theme
st-vsc-workspace-theme() {
    nw-dir .vscode
    local theme_file=".vscode/settings.json"
    if [ ! -f "$theme_file" ]; then
        touch "$theme_file"
    fi

    echo '{"workbench.colorTheme": "Dracula Theme"}' >> "$theme_file"
}

# set workspace color theme
st-vsc-docker-theme() {
    nw-dir .vscode
    local theme_file=".vscode/settings.json"
    if [ ! -f "$theme_file" ]; then
        touch "$theme_file"
    fi

    echo '{"workbench.colorTheme": "Dracula Theme"}' >> "$theme_file"
}
#= misc ====================================================================
pprint-csv() {
    column -t -s, $@
}

list-functions() {
    grep -E '^[a-zA-Z0-9_-]+\(\)' "${BASH_SOURCE[0]}" | sed 's/()//'
}

# Compress all pdf in a folder
# for pdf in *.pdf; do
#     if [[ -f "$pdf" ]]; then
#         compress-pdf "$pdf"
#     fi
# done
compress-pdf() {
    # ebook quality (see below to change output quality)

    if [[ -z "$1" ]]; then
        echo "Usage: compress_pdf \"input file.pdf\""
        return 1
    fi

    input_file="$1"
    # Extract the directory and base name of the input file
    dir=$(dirname "$input_file")/compressed
    base=$(basename "$input_file")
    mkdir -p $dir
    output_file="${dir}/${base}"

    # /screen → Lowest quality, smallest file size.
    # /ebook → Better quality, still compressed.
    # /printer → High quality, larger file.
    # /prepress → Best quality, minimal compression.
    # /default → Uses Ghostscript's default settings.

    ghostscript -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$output_file" "$input_file"

    echo "Compressed PDF saved as: $output_file"
}

