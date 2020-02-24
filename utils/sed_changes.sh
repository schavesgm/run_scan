#!/bin/bash 

# Script to be called from run_fit to generate all the needed sed manipulations

# -- MANIPULATE THE FOLDERS

# Inside automatic_fit.sh
sed -i "/numProc=/c\numProc=${NUM_MPI_PROC}" automatic_fit.sh
sed -i "/binSize=/c\binSize=${BIN_SIZE}" automatic_fit.sh
sed -i "/nBootBest=/c\nBootBest=${NUM_BOOTBEST}" automatic_fit.sh
sed -i "/nBootCalc=/c\nBootCalc=${NUM_BOOTFIT}" automatic_fit.sh 
# sed -i "/resBool=/c\resBool=${RES}" automatic_fit.sh 
sed -i "/resFactor=/c\resFactor=${RES_FACTOR}" automatic_fit.sh 
sed -i "/maxChiSq=/c\maxChiSq=${MAX_CHISQ}" automatic_fit.sh
# sed -i "/initGuess=/c\initGuess=( ${initGuess[0]} ${initGuess[1]} ${initGuess[2]} )" automatic_fit.sh 
# sed -i "/dimParam=/c\dimParam=${dimParam}" automatic_fit.sh
# sed -i "/ansatz=/c\ansatz=${ansatz}" automatic_fit.sh

# Inside launch_fit.sh
# sed -i "/channelFit=/c\channelFit=${channelFit}" launch_fit.sh
sed -i "/#SBATCH --ntasks=/c\#SBATCH --ntasks=${NUM_MPI_PROC}" launch_fit.sh
sed -i "/#SBATCH --tasks-per-node/c\#SBATCH --tasks-per-node=${NUM_MPI_PROC}" \
    launch_fit.sh
