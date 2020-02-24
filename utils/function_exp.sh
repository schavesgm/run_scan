#!/bin/bash

# Set rescaling boolean according to type
function set_bool() {
    case $1 in 
        'll')
            export RES_BOOL=0 ;;
        'ss')
            export RES_BOOL=1 ;;
    esac
    
    # In case you don't need rescaling for ll -- Ratios
    if [ -z $2 ]; then
        RES_BOOL=0
    fi

}

function set_init() {
    case $1 in
        'cosh')
            export DIM_PARAMS=2
            export INIT_GUESS=( $2 0.5 ) ;;
        'cosh-void')
            export DIM_PARAMS=3
            export INIT_GUESS=( $2 0.5 1 ) ;;
        'exp')
            export DIM_PARAMS=2
            export INIT_GUESS=( $2 0.5 ) ;;
    esac
}

function exp_vals() {
    # Export type of ansatz
    export ANSATZ=$3
    
    # Export type of calculation 
    export TYPE_CALC=$2 
    set_bool ${TYPE_CALC}

    case $1 in 
        'g5')
            export CHANNEL_FIT="g5"
            set_init $3 1 ;;
    esac
    

}
