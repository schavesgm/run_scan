import numpy as np
import sys

def get_syst_estimate( data, param ):
    """
    Function to return a systematic estimation of the value and the error given a
    scanned fit of the data. The function histograms all the data and picks the most
    repeated values, then it calculates the error using,

                        0.5 *  ( Maximum - Minimum ).
    In the case in which the data is unstable, then it will retrieve a value 
    corresponding to the average of the input data. The error will then be the 
    standard deviation of the data.

    Arguments:
        data ( np.array ):
            Array containing the data, the first column has to be the initial time
            that defines the time window, the second is the mass, third its error.
            If you do void fitting, then the fourth colum is the void and fifth is
            its error.
        param ( string = ['mass', void'] ):
            String that select which column to analyse in this run.
    Returns:
        estimation ( list ):
            List containing the value and the error estimated in the calculation.
    """

    if param == 'mass':
        col = 1
    elif param == 'void':
        col = 3
    
    run_mean = np.empty( data.shape[0] )
    run_stde = np.empty( data.shape[0] )

    # Calculate the running mean and standard deviation
    for i in range( data.shape[0] ):
        run_mean[i] = np.mean( data[i:,col] )
        run_stde[i] = np.std( data[i:,col] )

    # Histogram the running means
    hist, bin_edges = np.histogram( run_mean, bins = 'auto' )

    # Get the data froom the histogram into an array to sort the values
    cleaned_hist = np.empty( [3, hist.shape[0]] )
    for i in range( hist.shape[0] ):
        cleaned_hist[0,i] = hist[i]
        cleaned_hist[1,i] = bin_edges[i]
        cleaned_hist[2,i] = bin_edges[i+1]

    # Sort the histograms according to the number of bins in each case
    sort_hist = cleaned_hist[:, cleaned_hist[0].argsort()[::-1]]

    check_param, check_error = [], []
    aux_delta = 0
   
    # Get the values that are most repeated in the histogram

    for i in range( data.shape[0] ):
        if sort_hist[1,0] <= run_mean[i] <= sort_hist[2,0]:
            check_param.append( run_mean[i] )
            check_error.append( run_stde[i] )
    
    # Calculate the first estimation of the mean of the parameter
    value_param = np.mean( check_param )
    # Calculate the systematic error from the binning procedure
    sys_error = 0.5 * ( np.max( check_param ) - np.min( check_param ) )
    # Calculate the statistical error as the mean of standard deviations
    stat_error = np.mean( check_error )
    
    # Take care of problems in the calculation
    if sys_error > stat_error:
        return [ value_param, sys_error ]
    else:
        if sys_error == 0:  # Take care of only one point in the histogram
            new_error = 0.5 * ( np.max( data[:,col] ) - np.min( data[:,col] ) )
            return [ np.mean( data[:,col] ), new_error ]
        else:
            return [ value_param, stat_error ]

if __name__ == '__main__':

    file_name = sys.argv[1]
    data = np.loadtxt( file_name )
    estimation = get_syst_estimate( data, sys.argv[2] )
    print( estimation[0], estimation[1] )

