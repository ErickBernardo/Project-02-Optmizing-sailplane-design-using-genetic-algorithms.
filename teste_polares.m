% teste polares


close all
clear all
clc

global ngeom 
global H
global Vcd0_int;
global CD0_int;
global K_int;
global V_trim; 

ngeom = 0;
H = 0;


% Input aircraft   - Modelo SGS 135 (coluna AM - excel)
ARw = 23.3;
bw=15;
lambdaw = 0.4;
airfoil_w = 3;
twist=0;
xw=0.15;
tail_arrang=3;
airfoil_ht=1;
AR_ht = 4.16;
b_ht=3.5;
lambda_ht=0.8;
W = 422;
SM = 0.10;
cf_c_ht=0.5;

p = [ARw, bw, lambdaw, airfoil_w, twist, xw, tail_arrang, airfoil_ht, AR_ht, b_ht, lambda_ht, W, SM, cf_c_ht];
aircraft = read_from_parameters(p);


%% gráficos

polares(aircraft);



Vint = linspace(10,80,100);
Kint = interp1(V_trim,K_int,Vint,'PCHIP','extrap');
CDiint = interp1(Vcd0_int,CD0_int,Vint,'PCHIP','extrap');

plot(V_trim,K_int,'*')
hold on
plot(Vint,Kint)
xlabel('V')
ylabel('K')
grid on

figure
plot(Vcd0_int,CD0_int,'*')
hold on
plot(Vint,CDiint)
xlabel('V')
ylabel('CD0')
grid on



 

 

