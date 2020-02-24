#!/bin/bash

# Script to move the interest data to a fittin data
type_calc=$1
ROOT=$( pwd )
FITS_FOLDER="Fits"

case $2 in  # Define the channel type
    'g5') 
        name_fit_folder="Pseudoscalar"
        channel_save_name="g5_Folder" ;;
    *)
        echo "Channel name not currently defined" ;;
esac

        
# if [ ${channelFit} == 'g5' ]; then           # Pseudoscalar
#     lookFolder="g5_Folder"
# elif [ ${channelFit} == 'vec' ]; then        # Conc vector
#     lookFolder="vecConc_Folder"
# elif [ ${channelFit} == 'ax_plus' ]; then    # Conc axial plus
#     lookFolder="axConc_Folder"
# elif [ ${channelFit} == 'ax_minus' ]; then   # Conc axial minus
#     lookFolder="tespConc_Folder"
# elif [ ${channelFit} == 'g0' ]; then         # Scalar
#     lookFolder="g0_Folder"
# elif [ ${channelFit} == 'g6' ]; then         # Temporal axial \gamma_0
#     lookFolder="g6_Folder"
# elif [ ${channelFit} == 'axvec' ]; then      # Axial / Vector
#     lookFolder="axvecRatio_Folder"
# elif [ ${channelFit} == 'g0g5' ]; then       # Scalar / Pseudoscalar
#     lookFolder="g0g5Ratio_Folder"
# elif [ ${channelFit} == 'vecg5' ]; then      # Vector / Pseudoscalar
#     lookFolder="vecg5Ratio_Folder"
# fi
for meson in $( ls -d concMeson* )
do

    # Move into the hadron with definite type
    cd ${meson}/${type_calc}

    # Get the name of the file to generate its Folder_*
    chan_flavor=$( cd ${channel_save_name} && ls | sed "s/^/Folder_/" )

    # Move back to root directory
    cd $ROOT

    # Generate a folder to hold the data
    mkdir -p ./${FITS_FOLDER}/${name_fit_folder}/${type_calc}/${chan_flavor}

    # Copy the files inside the folder relative to the channel
    cp ./${meson}/${type_calc}/${channel_save_name}/* \
        ./${FITS_FOLDER}/${name_fit_folder}/${type_calc}/${chan_flavor}/
    
    # Copyt automat_fit file inside the folder to launch jobs
    cp ${RUN_FOLDER}/utils/automatic_fit.sh \
        ./${FITS_FOLDER}/${name_fit_folder}/${type_calc}/
    
    # Copy the launch_fit file inside the folder to launch jobs
    cp ${RUN_FOLDER}/utils/launch_fit.sh \
        ./${FITS_FOLDER}/${name_fit_folder}/${type_calc}/
done

# Copy the sed changes inside the folder
cp ${RUN_FOLDER}/utils/sed_changes.sh \
    ./${FITS_FOLDER}/${name_fit_folder}/${type_calc}/

# Copy the fit code inside the folder
cp ${RUN_FOLDER}/utils/fit_code.tar.gz \
    ./${FITS_FOLDER}/${name_fit_folder}/${type_calc}/

# Sed all the values using sed_changes.sh
( cd ./${FITS_FOLDER}/${name_fit_folder}/${type_calc}/ && \
    bash sed_changes.sh )

# Extract the fit_code folder
( cd ./${FITS_FOLDER}/${name_fit_folder}/${type_calc}/ && \
    tar -xf fit_code.tar.gz )

# Remove uneeded sed file
rm ./${FITS_FOLDER}/${name_fit_folder}/${type_calc}/sed_changes.sh

