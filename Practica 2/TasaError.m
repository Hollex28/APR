function terror = TasaError(fe,fle,fp,flp,numGaus)
	%Para ejecutar esta funcion utilizar
	% matlab -nodesktop -nosplash -nosoftwareopengl TasaError.m en la carpeta practica 2
	% TasaError('./spam/tr.dat','./spam/trlabels.dat','./spam/ts.dat','./spam/tslabels.dat',2) en matlab
	addpath('~/asigDSIC/ETSINF/apr/p2/BNT')
	addpath(genpathKPM('~/asigDSIC/ETSINF/apr/p2/BNT'))
	
	datApr = load(fe, '-ascii');
	etqApr = load(fle, '-ascii');
	
	dataApr = zscore(datApr);
	etiqApr = etqApr + 1;
	[numVec dim] = size(dataApr)
	numClas = max(etiqApr)

	grafo = [ 0 1 1 ; 0 0 1 ; 0 0 0 ];
	numNodos = length(grafo)
	tallaNodos = [numClas numGaus dim];
	nodosDiscretos = [1 2];
	redB = mk_bnet(grafo, tallaNodos, 'discrete', nodosDiscretos);
	redB.CPD{1} = tabular_CPD(redB, 1);
	redB.CPD{2} = tabular_CPD(redB, 2);
	redB.CPD{3} = gaussian_CPD(redB, 3, 'cov_type', 'diag');

	datosApr = cell(numNodos, numVec);
	datosApr(numNodos,:) = num2cell(dataApr', 1);
	datosApr(1,:) = num2cell(etiqApr', 1);
	motor = jtree_inf_engine(redB);
	maxIter = 16;
	[redB2, ll, motor2] = learn_params_em(motor, datosApr, maxIter);

	datTest = load(fp, '-ascii');
	etqTest = load(flp, '-ascii');
	dataTest = zscore(datTest);
	etiqTest = etqTest + 1;

	p = zeros(length(dataTest), numClas);
	evidencia = cell(numNodos,1);
	for i=1:length(dataTest)
		evidencia{numNodos} = dataTest(i,:)';
		[motor3, ll] = enter_evidence(motor2, evidencia);
		m = marginal_nodes(motor3, 1);
		p(i,:) = m.T';
	end
	terror = 0;
	for i=1:length(dataTest)
		if p(i,2) == etqTest(i)
			terror = terror + 1;%% Esto me saca el numero de resultados corretos
		end
	end
	npruebas=length(dataTest)
	terror= npruebas - terror %% El numero de fallos es la diferencia entre el numero de pruebas y resultados corretos
    PorcentajeError = terror/npruebas
end
