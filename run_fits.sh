#!/bin/bash -- login

# Script to fit all the possible temperatures of a given channel

# Check if variables are defined, they are needed
if [ -z ${1+x} ] || [ -z ${2+x} ] || [ -z ${3+x} ]; then 
   echo "You need to define the input variables 'channel' 'type' 'ansatz'"
   exit 1
fi

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
    export TIME_POINTS=$NT
    echo "I am processing $NT"
    
    # Copy move_to_chan_folder script inside the directory
    cp ${RUN_FOLDER}/utils/move_to_chan.sh ${ROOT_FOLDER}/${nt_dir} 

    # Execute it with the current properties
    ( cd ${ROOT_FOLDER}/${nt_dir} && bash move_to_chan.sh $1 $2 $3 )

    # Remove move_to_chan script
    rm ${ROOT_FOLDER}/${nt_dir}/move_to_chan.sh

done

