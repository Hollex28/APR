#!/usr/bin/octave -qf
# Ejercicio 5 Practica 1 APR

load("data/usps/tr.dat");
load("data/usps/trlabels.dat");
load("data/usps/ts.dat");
load("data/usps/tslabels.dat");

printf("      C\tk\t           e\t           i\n");
printf("=======\t=\t============\t============\n");

[N, D] = size(ts);

C = 0.01;
for k = 2
    while C <= 100
        if k == 1
            for d = [2:3]
                model = svmtrain(trlabels, tr, ["-q -t ", num2str(k), " -c ", num2str(C), " -d ", num2str(d)]);
                [prediction, accuracy, decision_values] = svmpredict(tslabels, ts, model, "-q");
                p = accuracy(1) / 100;
                confidence = 1.96 * sqrt(p * (1-p) / N);
                printf("%7d\t%1d\t%12f\t%12f\n", C, k+d, p, confidence);
            endfor
        else
            model = svmtrain(trlabels, tr, ["-q -t ", num2str(k), " -c ", num2str(C)]);
            [prediction, accuracy, decision_values] = svmpredict(tslabels, ts, model, "-q");
            p = accuracy(1) / 100;
            confidence = 1.96 * sqrt(p * (1-p) / N);
            printf("%7d\t%1d\t%12f\t%12f\n", C, k, p, confidence);
        endif
        C *= 10;
    endwhile
endfor

