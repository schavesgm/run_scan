#!/bin/bash -- login

# Script to fit all the possible temperatures of a given channel

# Check if variables are defined, they are needed
if [ -z ${1+x} ] || [ -z ${2+x} ] || [ -z ${3+x} ]; then 
   echo "You need to define the input variables 'channel' 'type' 'ansatz'"
   exit 1
fi

# Source globals 
source ./globals.sh

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

