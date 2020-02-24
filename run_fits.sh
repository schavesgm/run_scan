#!/bin/bash -- login

# Script to fit all the possible temperatures of a given channel

# -- GLOBALS
export NUM_MPI_PROC="40"
export BIN_SIZE="36"
export NUM_BOOTBEST="20000"
export NUM_BOOTFIT="20000"
export RES_FACTOR="1e9"
export MAX_CHISQ="100000"

# -- GLOBAL DIRECTORIES
export ROOT_FOLDER=$( cd ../ && pwd )
export RUN_FOLDER=$( pwd )

FOLDERS=$( cd ../ && ls -d data/128x32 | sort -n )
for nt_dir in ${FOLDERS[@]}
do  
    
    NT=$( echo $nt_dir | sed 's/data\///' | sed 's/x32//' )
    echo "I am processing $NT"
    
    # Copy move_to_chan_folder script inside the directory
    cp ${RUN_FOLDER}/utils/move_to_chan.sh ${ROOT_FOLDER}/${nt_dir} 

    # Execute it with the current properties
    ( cd ${ROOT_FOLDER}/${nt_dir} && bash move_to_chan.sh ll g5 )

    # Run the slurm job using launchFit.sh
# cd ./${nameFolderSave} && sbatch launchFit.sh

    # Remove move_to_chan script
    rm ${ROOT_FOLDER}/${nt_dir}/move_to_chan.sh

done

