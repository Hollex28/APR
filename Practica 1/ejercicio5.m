#!/usr/bin/octave -qf
# Ejercicio 5 Practica 1 APR

load("data/usps/tr.dat");
load("data/usps/trlabels.dat");
load("data/usps/ts.dat");
load("data/usps/tslabels.dat");

printf("   C   \t     e      \t      i     \n");
printf("=======\t============\t============\n");

[N, D] = size(ts);

C = 0.01;

while C <= 1000
    kernel = 1; #0 -> lineal, 1 -> polinomico , 2 -> radial
	pot = 2; # potencia del polinomio [2 o 3]
    model = svmtrain(trlabels, tr, ["-q -t ", num2str(kernel), " -c ", num2str(C), " -d ", num2str(pot)]); #solo polinomico
	#model = svmtrain(trlabels, tr, ["-q -t ", num2str(kernel), " -c ", num2str(C)]); #solo lineal or radial
    [prediction, accuracy, decision_values] = svmpredict(tslabels, ts, model, "-q");
    p = accuracy(1) / 100;
    confidence = 1.96 * sqrt(p * (1-p) / N);
    printf("%7d\t%12f\t%12f\n", C, p, confidence);
    C *= 10;
	
endwhile


