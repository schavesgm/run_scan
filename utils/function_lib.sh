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
            set_bool ${TYPE_CALC} 'No' ;;
        'g0')
            export CHANNEL_FIT="g0"
            export NAME_CHANNEL="Scalar"
            set_init $3 1
            set_bool ${TYPE_CALC} 'No' ;;
        'vec')
            export CHANNEL_FIT="vec"
            export NAME_CHANNEL="Vector_Spatial"
            set_init $3 -0.2
            set_bool ${TYPE_CALC} 'No' ;;
        'ax_plus')
            export CHANNEL_FIT="ax_plus"
            export NAME_CHANNEL="Ax_plus_Spatial"
            set_init $3 -0.2
            set_bool ${TYPE_CALC} 'No' ;;
       'ax_minus')
            export CHANNEL_FIT="ax_minus"
            export NAME_CHANNEL="Ax_minus_Spatial"
            set_init $3 -0.2
            set_bool ${TYPE_CALC} 'No' ;;
        *)
            echo "Channel is not currently defined"
            break ;;

   esac
}

function conc_values() {
    # Function to concatenate the correlation function of a given
    # channel into the same file. It is used by some channels as 
    # vector, axial...
    # Parameter $1 is the channel name
    # Parameter $2 is the inverse of the temperature
    # Parameter $3 is the meson to be concatenated
    case $1 in 
        'vec')
            mkdir -p vecConc_Folder
            cat g2_Folder/* g3_Folder/* g4_Folder/* > \
                vecConc_Folder/Gen2l_${2}x32.meson.vec.${3} ;;
        'ax_plus')
            mkdir -p axplusConc_Folder
            cat g7_Folder/* g8_Folder/* g9_Folder/* > \
                axplusConc_Folder/Gen2l_${2}x32.meson.ax_plus.${3} ;;
        'ax_minus')
            mkdir -p axminusConc_Folder
            cat g13_Folder/* g14_Folder/* g15_Folder/* > \
                axminusonc_Folder/Gen2l_${2}x32.meson.ax_minus.${3} ;;
        *)
            echo "Not needed concatenation for $1"
    esac
}
