set table "parity.pgf-plot.table"; set format "%.5f"
set format "%.7e";; set contour base; set cntrparam levels discrete 0.003; unset surface; set view map; set isosamples 700; splot y**2 - (x-1)*(x-2)*(x-3)*(x+1)*(x+2)*(x+3); splot y - (x**3 - 3*x + 7)/5; 
