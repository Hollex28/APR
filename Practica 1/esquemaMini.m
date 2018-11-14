#! /opt/octave/4.2.1/bin/octave

# Función que resuelve el problema. El primer argumento es para documentar
# los resultados y las gráficas.
#
function SVM (dataFileName, data, labels, C)
	load ('data/mini/' + data);
	load ('data/mini/' + labels);
	res = svmtrain(trlabels,tr,'-t 0 -c' + C);
	#mult lagrange
	lagrange = res.sv_coef;
	#vectoresS
	vectoresS = tr(res.sv_indices,:);
	#W = vector de pesos
	#Wo = Umbral
	w = lagrange' * vectoresS;
	wo = -res.rho;
	
# ... ... ...

pause
endfunction

# Main ------------------------------------------------------------------

# Elegimos el programa para visualización de gráficos:
#
graphics_toolkit gnuplot;

# Obtenemos los argumentos la línea de commando:  data_file labels_file C
#
arg_list = argv ();
eval(sprintf("data=load(\"-ascii\",\"%s\")",arg_list{1}));
eval(sprintf("labels=load(\"-ascii\",\"%s\")",arg_list{2}));
C=str2num(arg_list{3});
#
# un valor grande de C simula la optimización stándard del caso separable

# Invocamos la función que resuelve el problema
#
SVM(arg_list{1},data,labels,C);
# ------------------------------------------------------------------------
