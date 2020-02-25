#!/bin/bash

function set_bool() {
    # Function to set the rescaling boolean in the case
    # of ll or ss sources. If a second variable is defined,
    # then it will set it to zero. Useful for ratios of ss.
    case $1 in 
        'll')
            export RES_BOOL=0 ;;
        'ss')
            export RES_BOOL=1 ;;
    esac
    
    # In case you don't need rescaling for ss -- Ratios
    if [ -z ${2+x} ] && [ $2 == 'Ratio' ]; then
        export RES_BOOL=0
    fi
}

function set_init() {
    # Function to set the initial parameters of for the 
    # different channels and different ansatz
    case $1 in
        'cosh')
            export DIM_PARAMS=2
            INIT_GUESS=( $2 0.5 ) ;;
        'cosh-void')
            export DIM_PARAMS=3
            INIT_GUESS=( $2 0.5 1 ) ;;
        'exp')
            export DIM_PARAMS=2
            INIT_GUESS=( $2 0.5 ) ;;
    esac
}

function exp_vals() {
    # Function to set ansatz, type of calculation, initial
    # parameters and channel to be fit according to some
    # parameters.

    #  type of ansatz
    export ANSATZ=$3
    
    #  type of calculation 
    export TYPE_CALC=$2 

    case $1 in 
       'g5')
            export CHANNEL_FIT="g5"
            set_init $3 1
            set_bool ${TYPE_CALC} 'Ratio' ;;
       *)
           echo "Channel is not currently defined"
           break ;;

   esac
}

