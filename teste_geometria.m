% Teste geometria

close all
clear all
clc


global H ngeom

H = 0;
ngeom =0;;


%% Geometria e leitura de parâmetros

% ARw = [9 , 20];
% bw  = [6 , 18]; %[m]
% lambdaw =[0.1 ,  1]; 
% airfoil_w = [3 , 16]; % cada número corresponde a um aerofólio - varição nº inteiros
% twist = [0 , -5];  % [negativo washout - deg]
% xw = [1  4];  % [m]
% tail_arrang = [1 , 3] % 1:convencional - 2: cruz - 3: "T" - varição nº inteiros
% airfoil_ht = [1 , 2]; % cada número corresponde a um aerofólio - varição nº inteiros
% AR_ht = [1 , 6]; 
% b_ht = [0.5 , 5]; %[m]
% lambda_ht = [0.5 , 1];
% W = [250, 500]; %[kg]
% SM = [0.05, 0.10]; % limite de margem estática 
% cf_c = [0.1 , 0.5]; 

ARw = 7.9;
bw_Lf=1.5;
lambdaw = 0.27;
airfoil_w = 3;
twist=0;
xw=0.1;
tail_arrang=3;
airfoil_ht=1;
AR_ht = 6;
lambda_ht=0.3;
W = 204;
SM = 0.05;
cf_c_ht=0.1;


p = [ARw, bw_Lf, lambdaw, airfoil_w, twist, xw, tail_arrang, airfoil_ht, AR_ht, lambda_ht, W, SM, cf_c_ht];
aircraft = read_from_parameters(p);

% Vinf=50;
% CD0  = component_drag_CD0( aircraft, Vinf)

% i=1;
% for Vinf=20:5:150
%    CD0(i) =  component_drag_CD0( aircraft, Vinf);
%    i=i+1; 
% end    
% 
% Vinf=[20:5:150];
% plot(Vinf,CD0)
