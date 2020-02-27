#!/bin/bash

function check_values() {
    # Function to check if the needed input values are set and to check the
    # values they have
    
    echo "--"
    # Check if variables are defined, they are needed
    if [ -z ${1+x} ] || [ -z ${2+x} ] || [ -z ${3+x} ]; then 
       echo "You need to define the input variables 'channel' 'type' 'ansatz'"
       exit 1
    fi
    
    # Check variable values for type and ansatz
    case $2 in 
        'll') echo "You are using local-local sources" ;;
        'ss') echo "You are using smeared-smeared sources" ;;
        *)  
            echo "ERROR: Value of type not available"
            echo "       Current available values are 'll' and 'ss'"
            exit 1 ;;
    esac
    
    case $3 in 
        'cosh') echo "You are using cosh ansatz" ;;
        'cosh-void') echo "You are using cosh with a constant term ansatz" ;;
        'exp') echo "You are using a exponential fit" ;;
        *)
            echo "ERROR: Value of ansatz not available"
            echo "       Current available values are 'cosh', 'cosh-void' and 'exp'"
            exit 1;
    esac
    echo "--"
}

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
            export NAME_CHANNEL="Pseudoscalar"
            set_init $3 1
            set_bool ${TYPE_CALC} 'Ratio' ;;
       *)
           echo "Channel is not currently defined"
           break ;;

   esac
}

