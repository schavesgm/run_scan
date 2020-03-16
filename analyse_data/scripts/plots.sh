function echo_plot() {
    # The first argument is the meson
    # The second argument is the file to plot
    # The third argument is the output file 
    # The fourth argument is the param
    # The fifth argument is the channel and type

if [ $4 == 'mass' ]; then

echo "
file='$2'

# Set the style of the lines
set style line 1 lc rgb '#CD071E' pt 1 ps 1 lt 1 lw 2
set style line 2 lc rgb '#90CD071E' pt 1 ps 1 lt 1 lw 2

set style line 11 lc rgb '#808080' lt 1
set border 3 back ls 11
set tics nomirror

set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12

# Set labels and titles
set xlabel '$\\frac{\\tau}{N_\\tau\\cdot a_\\tau}$'
set ylabel '\$M \\cdot a_\\tau$'
set title '\$$1 - $4 - $5\$'

plot file u (1/\$1):2:3 w yerr ls 1 notitle, \\
     file u (1/\$1):2 w l ls 2 notitle
" > $3

elif [ $4 == 'void' ]; then

echo "
file='$2'

# Set the style of the lines
set style line 1 lc rgb '#CD071E' pt 1 ps 1 lt 1 lw 2
set style line 2 lc rgb '#90CD071E' pt 1 ps 1 lt 1 lw 2

set style line 11 lc rgb '#808080' lt 1
set border 3 back ls 11
set tics nomirror

set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12

# Set labels and titles
set xlabel '$\\frac{\\tau}{N_\\tau\\cdot a_\\tau}$'
set ylabel '$\\Phi \\cdot a_\\tau$'
set title '\$$1 - $4 - $5\$'

plot file u (1/\$1):4:5 w yerr ls 1 notitle, \\
     file u (1/\$1):4 w l ls 2 notitle
" > $3

fi
}

function plot_conc() {
    # The first argument $1 is cosh, void
    # The second argument $2 is the channel
    # The third argument $3 is the type

# Change plot in case for mass or void
if [ ${1} == 'mass' ]; then
    col_val=2
    col_err=3
    symbol='M'
elif [ ${1} == 'void' ]; then
    col_val=4
    col_err=5
    symbol='\Phi'
fi

# Get all plot files in the folder
file_cc=( $( ls params_cc* ) )
file_sc=( $( ls params_sc* ) )
file_uc=( $( ls params_uc* ) )
file_ss=( $( ls params_ss* ) )
file_us=( $( ls params_uc* ) )
file_uu=( $( ls params_uu* ) )

# Echo the plot out
echo "
file_cc='$file_cc'
file_sc='$file_sc'
file_uc='$file_uc'
file_ss='$file_ss'
file_us='$file_us'
file_uu='$file_uu'

set key above box

set style line 1 lc rgb '#ffbe4f' pt 1 ps 1 lt 1 lw 2
set style line 2 lc rgb '#80ffbe4f' pt 1 ps 1 lt 1 lw 2

set style line 3 lc rgb '#6bd2db' pt 2 ps 1 lt 1 lw 2
set style line 4 lc rgb '#806bd2db' pt 2 ps 1 lt 1 lw 2

set style line 5 lc rgb '#0ea7b5' pt 3 ps 1 lt 1 lw 2
set style line 6 lc rgb '#800ea7b5' pt 3 ps 1 lt 1 lw 2

set style line 7 lc rgb '#0c457d' pt 4 ps 1 lt 1 lw 2
set style line 8 lc rgb '#800c457d' pt 4 ps 1 lt 1 lw 2

set style line 9 lc rgb '#e8702a' pt 5 ps 1 lt 1 lw 2
set style line 10 lc rgb '#80e8702a' pt 5 ps 1 lt 1 lw 2

set style line 11 lc rgb '#EE4848' pt 6 ps 1 lt 1 lw 2
set style line 12 lc rgb '#80EE4848' pt 6 ps 1 lt 1 lw 2

set style increment user

set xlabel '\$T = \\frac{1}{N_\\tau}\$'
set ylabel '\$${symbol} \\cdot a_\\tau\$'
set title '\$ $1 - $2 - $3 \$'

set style line 15 lc rgb '#808080' lt 1
set border 3 back ls 15
set tics nomirror

plot file_uu u (1/\$1):${col_val}:${col_err} w yerr \\
        title sprintf( '%s', '\$\textnormal{uu}\$' ), \\
    file_uu u (1/\$1):$col_val w lp notitle, \\
    file_us u (1/\$1):$col_val:$col_err w yerr \\
        title sprintf( '%s', '\$\textnormal{us}\$' ), \\
    file_us u (1/\$1):$col_val w lp notitle, \\
    file_uc u (1/\$1):$col_val:$col_err w yerr \\
        title sprintf( '%s', '\$\textnormal{uc}\$' ), \\
    file_uc u (1/\$1):$col_val w lp notitle, \\
    file_ss u (1/\$1):$col_val:$col_err w yerr \\
        title sprintf( '%s', '\$\textnormal{ss}\$' ), \\
    file_ss u (1/\$1):$col_val w lp notitle, \\
    file_sc u (1/\$1):$col_val:$col_err w yerr \\
        title sprintf( '%s', '\$\textnormal{sc}\$' ), \\
    file_sc u (1/\$1):$col_val w lp notitle, \\
    file_cc u (1/\$1):$col_val:$col_err w yerr \\
        title sprintf( '%s', '\$\textnormal{cc}\$' ), \\
    file_cc u (1/\$1):$col_val w lp notitle
" > ./plot_it.gn
}
