#!/usr/bin/octave -qf
# Ejercicio 3 Practica 1



plot(1);
pause;

# Ejercicio 3 sep

load data/mini/trSep.dat   # tr
load data/mini/trSeplabels.dat # trlabels
    

#Entrenamiento de las muestras

res = svmtrain(trlabels,tr,'-t 0 -c 10');
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
