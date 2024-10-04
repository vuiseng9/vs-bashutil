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

ls-funcs() {
    declare -F | grep -v _
    # copy the line from the printout to see the function definition
    # or type <func>
}


#= GPU UTIL ================================================================
ns() {
    nvidia-smi $@
}

ns1() {
    nvidia-smi -l 1
}

nvdev() {
    if [ -z ${CUDA_VISIBLE_DEVICES} ]; then
        printfn "[Info]: CUDA_VISIBLE_DEVICES is not set"
    else
        printfn "[Info]: CUDA_VISIBLE_DEVICES = ${GREEN}${CUDA_VISIBLE_DEVICES}${NC}"
    fi    
}
#= File/Folder Management ==================================================

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

new-conda-env() {
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
#= GIT =====================================================================
gs() {
    git status $@
}

gr() {
    git remote -v
}

#= TMUX ====================================================================
ls-tmux() {
	tmux ls
}

#= misc ====================================================================
pprint-csv() {
    column -t -s, $@
}