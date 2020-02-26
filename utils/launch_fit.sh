#!/bin/bash

#SBATCH --job-name=128x32_g5_ll
#SBATCH --output=128x32_g5_ll
#SBATCH --error=ERROR.OUT
#SBATCH --ntasks=40
#SBATCH --tasks-per-node=40
#SBATCH --array=1

# Script to launch an array of jobs to fit all the data for a given
# channel and temperature

## Look inside each folder
calculate_flavors="Folder*"

## Name of the channel contained in the name -- used to get a proper name
channel=$1

for i in $( ls -d ${calculate_flavors} )
do
    sed -i "/foldName=/c\foldName='${i}'" ./automatic_fit.sh
    flavor_comp=$( echo "${i}" | sed "s/^.*${channel}/${channel}/" )
    sed -i "/typeOfHadron=/c\typeOfHadron='${flavor_comp}'" ./automatic_fit.sh
    echo "Estoy en el hadron ${flavor_comp}"
    bash ./automatic_fit.sh
    echo "-----"
done
