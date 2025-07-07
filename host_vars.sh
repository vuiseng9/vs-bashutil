declare -A vshomeroot
declare -A vsdevroot
declare -A vsrunroot
declare -A vscondaroot
declare -A vshfroot #hf cache

HOSTID=$(uname -n)
vshomeroot[$HOSTID]=/home/$USER/work
vscondaroot[$HOSTID]=/home/$USER/miniforge3
vsdevroot[$HOSTID]=/home/$USER/work/dev
vsrunroot[$HOSTID]=/home/$USER/work/run
vshfroot[$HOSTID]=/home/$USER/work/huggingface

VS_HOME_DIR=${vshomeroot[$HOSTID]}
VS_DEV_DIR=${vsdevroot[$HOSTID]}
VS_RUN_DIR=${vsrunroot[$HOSTID]}
VS_CONDA_DIR=${vscondaroot[$HOSTID]}
VS_HFCACHE_DIR=${vshfroot[$HOSTID]}
VS_PREFIX_CONDAENV=sf-$(datestr) # to be modified manually

if ! [ -z $VS_HFCACHE_DIR ] ; then
    export HF_HOME=$VS_HFCACHE_DIR
fi

vshome() {
    cd $VS_HOME_DIR
}

vsdev() {
    cd $VS_DEV_DIR
}

vsrun() {
    cd $VS_RUN_DIR
}

vsconda() {
    cd $VS_CONDA_DIR
}

vshf() {
    cd $VS_HFCACHE_DIR
}
