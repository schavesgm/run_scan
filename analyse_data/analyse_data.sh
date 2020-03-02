#!/bin/bash

# Global variables
NUM_BOOTS="20000"
BIN_SIZE="36"

INFOR=$( pwd )
INFOR=$( echo $INFOR | sed 's/.*Analyse_Data\///' )

# Retrieve the data from the path information
CHANNEL=$( echo $INFOR | sed -r 's/([a-zA-Z]+)\/(ll)\/([a-z]+-[a-z]+)/\1/' )
TYPE_CALC=$( echo $INFOR | sed -r 's/([a-zA-Z]+)\/(ll)\/([a-z]+-[a-z]+)/\2/' )
ANSATZ=$( echo $INFOR | sed -r 's/([a-zA-Z]+)\/(ll)\/([a-z]+-[a-z]+)/\3/' )

# Retrieve the dimensions
if [ $ANSATZ == 'cosh' ] || [ $ANSATZ == 'exp' ]; then
    DIM_PARAMS=2
    PARAMS=( 'mass' )
elif [ $ANSATZ == 'cosh-void' ]; then
    DIM_PARAMS=3
    PARAMS=( 'mass' 'void' )
fi

# Create folder to save the data
mkdir -p data_analysed

# Source the function on plots.sh
source ./scripts/plots.sh

# Get information about NT and mesons
NT=( 128 64 56 48 40 36 32 28 24 20 16 )
MESONS=( uu us ss uc sc cc )

for meson in ${MESONS[@]}
do
    
    echo "Processing meson ${meson}"
    echo "--"

    # Create the folder to hold all the meson data
    mkdir -p data_analysed/${meson}

    # Name of the file to flush the data to
    var_name="${meson}_${CHANNEL}_${TYPE_CALC}_${ANSATZ}_${NUM_BOOTS}_${BIN_SIZE}"
    name_save="params_${var_name}.dat"

    # Loop over all temperatures
    for nt in ${NT[@]}
    do
        
        echo "Results for Nt = ${nt}"
        flush_data=( "${nt} " )

        # Copy the sistematic error script into the folder
        cp ./scripts/sist_coeffs.py ${nt}/${meson}
        
        # Run the script into the folder
        dir="${nt}/${meson}"
        file_cleaned=$( cd ./${dir} && ls cleaned*${NUM_BOOTS}_*_${BIN_SIZE}.dat )

        for param in ${PARAMS[@]}
        do
            result=( $( cd ./${dir} && python ./sist_coeffs.py $file_cleaned $param ) )
            result=( $( python ./scripts/clean_value_error.py \
                        ${result[0]} ${result[1]} ) )
            flush_data+=( ${result[@]} )
            echo "Param ${param} = ${result[0]} +- ${result[1]}"
        done

        echo ${flush_data[@]} >> ./data_analysed/${meson}/${name_save}

        # Remove the script
        rm ${nt}/${meson}/sist_coeffs.py
        
    done

    # Now plot all the data
    for param in ${PARAMS[@]} 
    do
        echo_plot ${meson} ${name_save} ./data_analysed/${meson}/plots.gn ${param}
        (  cd ./data_analysed/${meson}/ && \
           gnp2tex -f plots.gn -s ${param}_${meson}.pdf )
    done

    echo "--"

done

# Move the plots inside a folder
mkdir -p data_analysed/plots/mass data_analysed/plots/void
cp ./data_analysed/*/mass* data_analysed/plots/mass
cp ./data_analysed/*/void* data_analysed/plots/void
