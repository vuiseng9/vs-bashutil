declare -A vshomeroot
declare -A vsdevroot
declare -A vsrunroot
declare -A vscondaroot
declare -A vshfroot #hf cache

vshomeroot['MSI']=/workspace
vsdevroot['MSI']=/workspace/dev
vsrunroot['MSI']=/workspace/run
vscondaroot['MSI']=/home/vuiseng9/miniforge3

HOSTID=$(uname -n)
VS_HOME_DIR=${homeroot[$HOSTID]}
VS_DEV_DIR=${devroot[$HOSTID]}
VS_RUN_DIR=${runroot[$HOSTID]}
VS_CONDA_DIR=${condaroot[$HOSTID]}
VS_HFCACHE_DIR=${vshfroot[$HOSTID]}
