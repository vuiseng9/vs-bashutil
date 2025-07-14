declare -A vshomeroot
declare -A vsdevroot
declare -A vsrunroot
declare -A vscondaroot
declare -A vshfroot #hf cache

vshomeroot['MSI']=/root/work
vsdevroot['MSI']=/root/work/dev
vsrunroot['MSI']=/root/work/run
vscondaroot['MSI']=/root/miniforge3
vshfroot['MSI']=/root/work/huggingface

HOSTID=$(uname -n)
VS_HOME_DIR=${vshomeroot[$HOSTID]}
VS_DEV_DIR=${vsdevroot[$HOSTID]}
VS_RUN_DIR=${vsrunroot[$HOSTID]}
VS_CONDA_DIR=${vscondaroot[$HOSTID]}
VS_HFCACHE_DIR=${vshfroot[$HOSTID]}
VS_PREFIX_CONDAENV=aegis-$(datestr)

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
