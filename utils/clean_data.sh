#!/bin/bash 

# Script to clean the data after being fit to make it
# easy to be analysed

# Properties of the data - As input arguments
raw_file=$( ls ${CHANNEL_FIT}* ) 
output_file="cleaned_${raw_file}"

# Get rid of unwanted data

# Eliminate the Amplitude from the data
sed '/Param : 1/d' ./$raw_file > $output_file

# Eliminate the chiSquare obtained from the data
sed -i '/ChiSquare/d' ./$output_file
 
# Treatment is different if we work in 3 or 2 dimensions
sed -i 's/Param : 2 is //' ./$output_file
 
if [ ${DIM_PARAMS} == 3 ]; then
    sed -i 's/Param : 3 is //' ./$output_file
fi

# Eliminate unwanted comments
sed -i '/# --/d' ./$output_file
sed -i 's/Time Window is //' ./$output_file
sed -i 's/+-//' ./$output_file

# Remove space between lines
# sed -i 'N;s/\n/ /' ./$output_file

# I can remove the last point which is nan
head -n -2 ./${output_file} > temp.file 
mv temp.file ${output_file} 

if [ ${DIM_PARAMS} == 3 ]; then
    sed -i '$d' ./$output_file
fi

# Loop to generate a new file
touch temp.file
aux_counter=0
array_values=()

while read LINE
do
    case $aux_counter in
        0) 
            # Get the initial time
            value=$( echo $LINE | awk '{ print $1 }' | sed 's/-.*//' )
            value=( ${value[0]} ) ;;
        1)
            # Get the value of the mass
            value=( $( echo $LINE | awk '{ print $1 " " $2 }' )) ;;
        2) 
            # Get the value of the void if needed
            value=( $( echo $LINE | awk '{ print $1 " " $2 }' )) ;;
    esac
    array_values+=( ${value[@]} )
    aux_counter=$(( $aux_counter + 1 ))
    
    if [ $aux_counter == ${DIM_PARAMS} ]; then
        echo ${array_values[@]} >> temp.file
        aux_counter=0
        array_values=()
    fi

done < $output_file

# Get the wanted file back
mv temp.file $output_file


