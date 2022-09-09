% Teste airfoil_properties
% OK [x]

close all
clear all
clc

global read_airfoil;

read_airfoil = 1

geometry.span=  10.9728 ;
geometry.AR = 6;
geometry.MAC = 1.8288;
geometry.ct = 1.8288 ;
geometry.S = 20.07;
geometry.cr = 1.8288;
geometry.twist = 0; %washout
geometry.airfoil=6; % 
Vinf = 70;
amb.rho=1.225;
amb.visc = 1.79*10^-5;

Re=(amb.rho*Vinf*geometry.MAC)/amb.visc

[Clalpha_inf,CLalpha, alpha0, t_c, x_c_max] = airfoil_properties(geometry,amb,Vinf)


