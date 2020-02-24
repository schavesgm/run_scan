#!/bin/bash -- login

# Script to fit all the possible temperatures of a given channel

# -- GLOBALS
num_MPI_proc="40"
bin_size="36"
num_bootbest="20000"
num_bootcalc="20000"
res_factor="1e9"
max_chisq="100000"
ROOT_FOLDER=$( pwd )

FOLDERS=$( cd ../ && ls -d data/128x32 | sort -n )
for nt_dir in ${FOLDERS[@]}
do  
    
    NT=$( echo $nt_dir | sed 's/data\///' | sed 's/x32//' )
    echo "I am processing $NT"
    
    # Copy move_to_folder script inside the directory
    cp ${ROOT_FOLDER}/utils/move_to_fit_folder.sh ${nt_dir} 

    ## Change job name inside launcFit.sh
# sed -i "/#SBATCH --job-name/c\#SBATCH --job-name=${dir}_${channelFit}_${typeCalc}" \
    # launchFit.sh
# sed -i "/#SBATCH --output/c\#SBATCH --output=${dir}_${channelFit}_${typeCalc}" \
# launchFit.sh
    
    
    ## Change the time extent in each file
# timePoints=$( echo ${dir} | sed "s/x.*//" )
#   sed -i "/timePoints=/c\timePoints=${timePoints}" automaticFit.sh 

    # ## Copy and run moveToFolder to the directory
# mkdir -p ${nameFolderSave}
#     bash moveToFolder.sh && rm moveToFolder.sh
#     cp ../scanRunServer/automaticFit.sh ./${nameFolderSave}
#     cp ../scanRunServer/cppFitCode.tar.gz ./${nameFolderSave}
#     cp ../scanRunServer/launchFit.sh ./${nameFolderSave}
# 
#     # Run the slurm job using launchFit.sh
#     cd ./${nameFolderSave} && sbatch launchFit.sh

done

