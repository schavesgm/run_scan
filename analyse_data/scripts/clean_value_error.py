import sys
import numpy as np

# Get index of the last zero in the error
def last_zero( string_error ):
    """ 
    Returns the last zero encountered in a error string. This error 
    corresponds to the rounding error.
    Arguments:
        string_error (string):
            String containing the value of the error to be rounded
    Returns:
        index_last (int):
            Position of the last zero from the beginning in 
            string_error
    """
    index_last = 0
    for index, char in enumerate( string_error ):
        if char == '0' or char == '.':
            index_last = index
        else:
            break

    return index_last

# Values to be rounded
value = sys.argv[1]
error = sys.argv[2]

# Generate the rounded values
pos_zero = last_zero( error )
clean_error = np.round( float( error ), pos_zero )
clean_value = np.round( float( value ), pos_zero )


# Return the value 
print( clean_value, clean_error )
