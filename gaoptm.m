% Optimization using genetic algorithms
% Erick Bernardo - 2017 - Aero013
% Script principal - executar s� esse script.

% Status: Programado [x] Verificado [x] Validado [x]

% close all
% clear all
% clc

%Vari�veis que ser�o variadas pelo algoritmo gen�tico 
% Defini��o dos limites de varia��o  [valor_inferior  valor_superior]
%ARw = [7.9 , 39.8];
ARw = [15 , 39.8];
bw_Lf  = [1.46 , 2.85]; % raz�o span/Lf
lambdaw =[0.27 ,  1]; 
airfoil_w = [3 , 11]; % cada n�mero corresponde a um aerof�lio - vari��o n� inteiros
twist = [-5 , 0];  % [negativo washout - deg]
xw = [2.1  2.4];  % [posi��o certa - m]
tail_arrang = [1 , 3]; % 1:convencional - 2: cruz - 3: "T" - vari��o n� inteiros
airfoil_ht = [1 , 2]; % cada n�mero corresponde a um aerof�lio - vari��o n� inteiros
AR_ht = [1.86 , 7.29]; % BD sailplane 
lambda_ht = [0.3 , 0.5];
W = [204, 850]; %[kg]
SM = [0.05, 0.15]; % limite de margem est�tica 
cf_c = [0.05 , 0.5]; % posi��o do profrundor no HT

%apagar depois do teste
%airfoil_w = [3 , 6];


% limites
% p = [ARw, bw, lambdaw, airfoil, twist, xw, tail_arrang, airfoil_ht, AR_ht, b_ht, lambda_ht, W, SM, cf_c_ht]  
LB = [ARw(1), bw_Lf(1), lambdaw(1), airfoil_w(1), twist(1), xw(1), tail_arrang(1), airfoil_ht(1), AR_ht(1), lambda_ht(1), W(1), SM(1), cf_c(1)];
UB = [ARw(2), bw_Lf(2), lambdaw(2), airfoil_w(2), twist(2), xw(2), tail_arrang(2), airfoil_ht(2), AR_ht(2), lambda_ht(2), W(2), SM(2), cf_c(2)];

% nval = 13;
% opts = gaoptimset('PlotFcns',@gaplotbestf);
% IntCon = [4,7,8]; % defino as vari�veis que ter�o varia��o entre n�meros inteiros
% 
% [res,fval,exitflag,output,population,scores] = ga(@f,nval,[],[],[],[],LB,UB,[],IntCon,opts);


%% Delta H


nval = 13;
IntCon = [4,7,8]; % defino as vari�veis que ter�o varia��o entre n�meros inteiros
[res,fval,exitflag,output,population,scores] = ga(@f,nval,[],[],[],[],LB,UB,[],IntCon);



