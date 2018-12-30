#!/usr/bin/octave -qf
# Ejercicio 3 Practica 1


plot(1);
pause;

# Ejercicio 3 nosep

load data/mini/tr.dat   # tr
load data/mini/trlabels.dat # trlabels
    
C = 1000;
	
#Entrenamiento de las muestras

res = svmtrain(trlabels,tr,'-t 0 -c 1000');
lagrange = res.sv_coef;
    
# Vectores soporte

vector_soporte = tr(res.sv_indices,:);

# Vector de pesos, umbral

w  = lagrange' * vector_soporte;
w0 = -res.rho;

# Margen
margen = 1 / (w * w');

# Recta y margenes (1 y 2)
m  = -  w(1)/w(2);
b  = -  w0 / w(2);
b1 = - (w0 - 1) / w(2);
b2 = - (w0 + 1) / w(2);

X  = [1:0.001:7];
Y  = m * X + b ;
Y1 = m * X + b1;
Y2 = m * X + b2;

plot(X, Y, X, Y1, X, Y2,
     tr(trlabels==1, 1), tr(trlabels==1, 2), 'o',
     tr(trlabels==2, 1), tr(trlabels==2, 2), 'x',
     tr(res.sv_indices, 1), tr(res.sv_indices, 2), '+');
    pause;

# Calcular tolerancia del margen de cada dato de tr


tolerancia_margen_sv = (abs(lagrange) == C) .* (1 - sign(lagrange) .* (vector_soporte * w' + w0));
tolerancia_margen = zeros(size(trlabels));
tolerancia_margen(res.sv_indices) = tolerancia_margen_sv;
multiplicadores_lagrange = zeros(size(trlabels));
multiplicadores_lagrange(res.sv_indices) = res.sv_coef;

# Representacion grafica marcando los valores erroneos

# Representacion grafica indicando valores de C != 0

plot(
	X, Y, 'g',
	X, Y1, 'b',
	X, Y2, 'r',
	tr(trlabels==1,1), tr(trlabels==1,2), 'sr',
	tr(trlabels==2,1), tr(trlabels==2,2), '.b',
	tr(tolerancia_margen!=0,1), tr(tolerancia_margen!=0,2), "xk",
	res.SVs(tolerancia_margen_sv==0,1),res.SVs(tolerancia_margen_sv==0,2), "+k"
);
pause;


