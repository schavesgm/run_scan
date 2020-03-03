#!/bin/bash

# Script to fetch the data from a calculation
source ./utils/function_lib.sh

# Check the input values
check_values $1 $2 $3

# Source global values
source ./globals.sh

# Source function values to get the data from
exp_vals $1 $2 $3
echo 

# All possible mesons available
MESONS=( uu us uc ss sc cc )

# Create the output data in the root directory
export ROOT_FOLDER=$( cd ../ && pwd )
mkdir -p ${ROOT_FOLDER}/outputs

# Create folder with name of the channel inside outputs
DIR_OUTPUT=${ROOT_FOLDER}/outputs/${NAME_CHANNEL}/${TYPE_CALC}/${ANSATZ}
mkdir -p ${DIR_OUTPUT} 

# Array containing the values of NT used
FOLDERS=$( cd ../ && ls -d data/*x32 | sort -Vr )
for nt_dir in ${FOLDERS[@]}
do  
    
    # Current value of NT
    NT=$( echo $nt_dir | sed 's/data\///' | sed 's/x32//' )
    export TIME_POINTS=$NT
    echo "I am processing $NT"
    
    # Create a folder inside DIR_OUTPUT for each value of NT
    mkdir -p ${DIR_OUTPUT}/${TIME_POINTS}
    
    # Directory containing the data
    DIR_DATA=${ROOT_FOLDER}/${nt_dir}/Fits/${NAME_CHANNEL}/${TYPE_CALC}/${ANSATZ}
    
    for meson in ${MESONS[@]}
    do

        # Create a folder for each meson inside NT
        mkdir -p ${DIR_OUTPUT}/${TIME_POINTS}/${meson}

        # We do need to move the fitted data and best estimate to folder
        name_best="bestEstimate_${CHANNEL_FIT}*_${NUM_BOOTBEST}_*_${BIN_SIZE}.dat"
        cp ${DIR_DATA}/Folder*.${meson}/${name_best} \
            ${DIR_OUTPUT}/${TIME_POINTS}/${meson}

        fit_data="${CHANNEL_FIT}*_${NUM_BOOTBEST}_*_${BIN_SIZE}.dat"
        cp ${DIR_DATA}/Folder*.${meson}/${fit_data} \
            ${DIR_OUTPUT}/${TIME_POINTS}/${meson}

        # Now, we clean the data
        cp ./utils/clean_data.sh ${DIR_OUTPUT}/${TIME_POINTS}/${meson}
        
        ( cd ${DIR_OUTPUT}/${TIME_POINTS}/${meson}/ && bash clean_data.sh )
        ( cd ${DIR_OUTPUT}/${TIME_POINTS}/${meson}/ && rm clean_data.sh )

    done

done
