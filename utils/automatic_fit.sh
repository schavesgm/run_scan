#!/bin/bash 

# -- GLOBALS TO BE SED FROM OUTSIDE
foldName='Folder_Gen2l_128x32.meson.g5.cc'
typeOfHadron='g5.cc'
timePoints=128
colSize=3
maxChiSq=100000
binSize=36
nBootBest=20000
nBootCalc=20000
resBool=0
resFactor=1e9


dimParam=3
initGuess=( 1 0.5 1 )

# -- Parameters of the converge fit file
numProc=40
improvBreak=0.0001
maxIter=6

tInit=1
tFini=$( echo "${timePoints}/2-1" | bc )

ansatz=cosh-void

# -- CHANGE INPUT FILES
resultFile="${typeOfHadron}_${foldName}_resultsFile_${nBootCalc}_${dimParam}_${binSize}.dat"
resultFile=$( echo "$resultFile" | sed 's/_Folder//g' )
resultFile=$( echo "$resultFile" | sed 's/ /-/g' )

echo "# --" > ./$foldName/$resultFile

## Directory to input file
dirInput="./${foldName}/input.in"

## Copy the fitting code inside the folder
tar -xvf fit_code.tar.gz

# Change the time extent of the function to fit
sed -i "/\#define TIME_EXTENT/c\#define TIME_EXTENT ${timePoints}" \
       ./fit_code/fitMain.cpp

case ${ansatz} in 
    'cosh')
        sed -i "/\#define ANSATZ/c\#define ANSATZ 0" \
            ./fit_code/fitMain.cpp ;;
    'cosh-void')
        sed -i "/\#define ANSATZ/c\#define ANSATZ 2" \
            ./fit_code/fitMain.cpp ;;
    'exp')
        sed -i "/\#define ANSATZ/c\#define ANSATZ 1" \
            ./fit_code/fitMain.cpp ;;
esac 

# -- LOOP OVER DIFFERENT TIME WINDOWS 
for i in $( seq  ${tInit} 1 ${tFini} )
do
    
    inTime=$i
   
    case ${ansatz} in 
        'cosh') 
            fnTime=$( echo "${timePoints} - $i" | bc ) ;;
        'cosh-void')
            fnTime=$( echo "${timePoints} - $i" | bc ) ;;
        'exp')
            fnTime=$( echo "${timePoints}/2" | bc ) ;;
    esac

    echo "I am using TW = $inTime - $fnTime" 

    # Copy inside the folder
    cp -r ./fit_code/* ${foldName}
    
    # Change input file
    fileName=$( ls ./${foldName}/*.${typeOfHadron} | xargs -n 1 basename )
    numLines=$( wc -l < ./${foldName}/*.${typeOfHadron} )
    
    # Get the file parameters inside input,in
    sed -i "/paramsFile/c\paramsFile ${numLines} ${colSize} ${timePoints}" ${dirInput}
    sed -i "/initSeed/c\initSeed $(( RANDOM % 10000000 ))" ${dirInput}
    sed -i "/binSize/c\binSize ${binSize}" ${dirInput}
    sed -i "/fileName/c\fileName ${fileName}" ${dirInput}
    sed -i "/windowFit/c\windowFit ${inTime} ${fnTime}" ${dirInput}
    sed -i "/saveName/c\saveName bestEstimate_${resultFile}" ${dirInput}
    sed -i "/largestChiSquare/c\largestChiSquare ${maxChiSq}" ${dirInput}
    sed -i "/dimParam/c\dimParam ${dimParam}" ${dirInput}
    sed -i "/initGuess/c\initGuess" ${dirInput}
    sed -i "/explGuess/c\explGuess" ${dirInput}
    sed -i "/rescaleOrNot/c\rescaleOrNot ${resBool}" ${dirInput}
    sed -i "/rescaledFactor/c\rescaledFactor ${resFactor}" ${dirInput}
    
    for (( i = 0; i < $dimParam; i++ ))
    do
        sed -i "/initGuess/ s/$/ ${initGuess[$i]}/" ${dirInput}
        sed -i "/explGuess/ s/$/ ${initGuess[$i]}/" ${dirInput}
    done
    
    # Change convergeFit.sh file
    sed -i "/--ntasks=/c\\\#SBATCH --ntasks=${numProc}" ./${foldName}/convergeFit.sh
    sed -i "/resultFile=/c\resultFile='${resultFile}'" ./${foldName}/convergeFit.sh
    sed -i "/Nproc=/c\Nproc=${numProc}" ./${foldName}/convergeFit.sh
    sed -i "/improvBreak=/c\improvBreak=${improvBreak}" ./${foldName}/convergeFit.sh
    sed -i "/maxIter=/c\maxIter=${maxIter}" ./${foldName}/convergeFit.sh
    sed -i "/numBootBest=/c\numBootBest=${nBootBest}" ./${foldName}/convergeFit.sh
    sed -i "/numBootCalc=/c\numBootCalc=${nBootCalc}" ./${foldName}/convergeFit.sh
    sed -i "/timeWindow=/c\timeWindow=${inTime}-${fnTime}" ./${foldName}/convergeFit.sh
    
    cd ./${foldName} && bash convergeFit.sh && cd ..

done

