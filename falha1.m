% Teste falhas

% 1 problema: falta de extrapola��o na interp1 da fun��o deltaCL: Resolvido [x]

close all
clear all
clc

global H ngeom

H=0;
ngeom = 0;

load('geometrias\pgeom1.mat')
p = pgeom;
aircraft = read_from_parameters(p);


polares(aircraft);

