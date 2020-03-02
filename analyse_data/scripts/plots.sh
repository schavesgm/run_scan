function echo_plot() {
    # The first argument is the meson
    # The second argument is the file to plot
    # The third argument is the output file 
    # The fourth argument is the param

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
set title '$1 - $4'

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
set ylabel '\$\\Phi \\cdot a_\\tau$'
set title '$1 - $4'

plot file u (1/\$1):4:5 w yerr ls 1 notitle, \\
     file u (1/\$1):4 w l ls 2 notitle
" > $3

fi
}
