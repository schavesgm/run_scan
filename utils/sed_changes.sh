#!/bin/bash 

# Script to be called from run_fit to generate all the needed sed manipulations

# -- MANIPULATE THE FOLDERS
INIT_GUESS=( ${1} ${2} ${3} )

# Inside automatic_fit.sh
sed -i "/numProc=/c\numProc=${NUM_MPI_PROC}" automatic_fit.sh
sed -i "/binSize=/c\binSize=${BIN_SIZE}" automatic_fit.sh
sed -i "/nBootBest=/c\nBootBest=${NUM_BOOTBEST}" automatic_fit.sh
sed -i "/nBootCalc=/c\nBootCalc=${NUM_BOOTFIT}" automatic_fit.sh 
sed -i "/resBool=/c\resBool=${RES_BOOL}" automatic_fit.sh 
sed -i "/resFactor=/c\resFactor=${RES_FACTOR}" automatic_fit.sh 
sed -i "/maxChiSq=/c\maxChiSq=${MAX_CHISQ}" automatic_fit.sh
sed -i "/initGuess=/c\initGuess=( ${INIT_GUESS[0]} ${INIT_GUESS[1]} ${INIT_GUESS[2]} )" automatic_fit.sh 
sed -i "/dimParam=/c\dimParam=${DIM_PARAMS}" automatic_fit.sh
sed -i "/ansatz=/c\ansatz=${ANSATZ}" automatic_fit.sh
sed -i "/timePoints=/c\timePoints=${TIME_POINTS}" automatic_fit.sh 

# Inside launch_fit.sh
sed -i "/#SBATCH --job-name/c\\\#SBATCH --job-name=${TIME_POINTS}_${CHANNEL_FIT}_${TYPE_CALC}" \
    launch_fit.sh
sed -i "/#SBATCH --output/c\\\#SBATCH --output=${TIME_POINTS}_${CHANNEL_FIT}_${TYPE_CALC}" \
    launch_fit.sh
sed -i "/channelFit=/c\channelFit=${CHANNEL_FIT}" launch_fit.sh
sed -i "/#SBATCH --ntasks=/c\#SBATCH --ntasks=${NUM_MPI_PROC}" launch_fit.sh
sed -i "/#SBATCH --tasks-per-node/c\#SBATCH --tasks-per-node=${NUM_MPI_PROC}" \
    launch_fit.sh
