declare -A vshomeroot
declare -A vsdevroot
declare -A vsrunroot
declare -A vscondaroot
declare -A vshfroot #hf cache

vshomeroot['MSI']=/home/vuiseng9
vsdevroot['MSI']=/workspace/dev
vsrunroot['MSI']=/workspace/run
vscondaroot['MSI']=/home/vuiseng9/miniforge3
# vshfroot['MSI']=

HOSTID=$(uname -n)
VS_HOME_DIR=${vshomeroot[$HOSTID]}
VS_DEV_DIR=${vsdevroot[$HOSTID]}
VS_RUN_DIR=${vsrunroot[$HOSTID]}
VS_CONDA_DIR=${vscondaroot[$HOSTID]}
VS_HFCACHE_DIR=${vshfroot[$HOSTID]}

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