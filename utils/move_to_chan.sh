#!/bin/bash

# Script to move the interest data to a fittin data
ROOT=$( pwd )
FITS_FOLDER="Fits"

# Define the variables from the input parameters
source ${RUN_FOLDER}/utils/function_lib.sh
exp_vals $1 $2 $3

case $1 in  # Define all kinds of channel types available
    "g5") 
        name_fit_folder="Pseudoscalar"              # Pseudoscalar - 0-+
        channel_save_name="g5_Folder" ;;
    "vec")
        name_fit_folder="Vector_Spatial"            # Vector - 1--
        channel_save_name="vecConc_Folder" ;;
    "ax_plus")
        name_fit_folder="Ax_plus_Spatial"           # Axial plus - 1++
        channel_save_name="axplusConc_Folder" ;;
    "ax_minus")
        name_fit_folder="Ax_minus_Spatial"          # Axial minus - 1+-
        channel_save_name="axminusConc_Folder" ;;
    "g0")
        name_fit_folder="Scalar"                    # Scalar - O++
        channel_save_name="g0_Folder" ;;
    *)
        echo "Channel name not currently defined" 
        exit 1 ;;
esac

PATH_TO_FIT="./${FITS_FOLDER}/${name_fit_folder}/${TYPE_CALC}/${ANSATZ}"
for meson in $( ls -d concMeson* )
do

    # Move into the hadron with definite type
    cd ${meson}/${TYPE_CALC}

    # Create the concatenation of files if needed
    flavor=$( echo $meson | sed 's/concMeson.//' )
    conc_values $1 ${TIME_POINTS} ${flavor}

    # Get the name of the file to generate its Folder_*
    chan_flavor=$( cd ${channel_save_name} && ls | sed "s/^/Folder_/" )

    # Move back to root directory
    cd $ROOT

    # Generate a folder to hold the data
    mkdir -p ${PATH_TO_FIT}/${chan_flavor}

    # Copy the files inside the folder relative to the channel
    cp ./${meson}/${TYPE_CALC}/${channel_save_name}/* ${PATH_TO_FIT}/${chan_flavor}/

    # Copy automatic_fit file inside the folder to launch jobs
    cp ${RUN_FOLDER}/utils/{automatic_fit.sh,launch_fit.sh} ${PATH_TO_FIT}

done

# Copy the sed changes inside the folder
cp ${RUN_FOLDER}/utils/sed_changes.sh ${PATH_TO_FIT} 

# Copy the fit code inside the folder
cp ${RUN_FOLDER}/utils/fit_code.tar.gz ${PATH_TO_FIT}

# Sed all the values using sed_changes.sh
( cd ${PATH_TO_FIT} && bash sed_changes.sh ${INIT_GUESS[@]} )

# Extract the fit_code folder
( cd ${PATH_TO_FIT} && tar -xf fit_code.tar.gz )

# Remove uneeded sed file after being used
rm ${PATH_TO_FIT}/sed_changes.sh

# Launch batch job using launch_fit.sh
( cd ${PATH_TO_FIT} && sbatch launch_fit.sh $1 )

