% Teste generate polars
% Obs: generate_polars e airfoil_properties funcionais.

clear all
close all
clc

global H ngeom
global Clalpha_inf_w CLalpha_w alpha0_w t_c_w x_c_max_w;
global Clalpha_inf_ht CLalpha_ht alpha0_ht t_c_ht x_c_max_ht;


ngeom =0;
H =0;


%% NACA report data    - calculando CL e só CDi  Status: Completo[x]

% % Input aircraft   - Modelo SGS 135 (coluna AM - excel)
% ARw = 23.3;
% bw=15;
% lambdaw = 0.4;
% airfoil_w = 3;
% twist=-5;
% xw=0.15;
% tail_arrang=3;
% airfoil_ht=1;
% AR_ht = 4.16;
% b_ht=3.5;
% lambda_ht=0.8;
% W = 422;
% SM = 0.10;
% cf_c_ht=0.5;
% 
% p = [ARw, bw, lambdaw, airfoil_w, twist, xw, tail_arrang, airfoil_ht, AR_ht, b_ht, lambda_ht, W, SM, cf_c_ht];
% aircraft = read_from_parameters(p);
% 
% Vinf = 26.0604;
% 
% [Clalpha_inf,CLalpha, alpha0, t_c, x_c_max] = airfoil_properties(aircraft.wing,aircraft.amb,Vinf)
% 
% Clalpha_inf_w = Clalpha_inf ;
% alpha0_w = alpha0;
% 
% i=1;
% for alpharoot = -8: 1 : 24 
%        polars = generate_polars(aircraft.wing, aircraft.amb, Vinf, alpharoot,2);
%        %plot_load( geometry, amb, Vinf, polars)
%        %grid on
%        CL(i) = polars.CL;
%        CDi(i) = polars.CDi;
%        % acrescentar CD0 - AQUI
%        alpha(i)=alpharoot;
%        %hold on
%        i=i+1;
% end       
%        
% 
% plot(alpha,CL)
% xlabel('alpha')
% ylabel('CL')
% grid on
% 
% figure
% 
% plot(alpha, CDi)
% xlabel('alpha')
% ylabel('CDi')
% grid on

%% Testar parâmetros de saída - Status: Completo [x]  

% geometry.span=  10.9728 ;
% geometry.AR = 6;
% geometry.MAC = 1.8288;
% geometry.ct = 1.8288 ;
% geometry.S = 20.07;
% geometry.cr = 1.8288;
% geometry.twist = 0; %washout
% geometry.airfoil=14; % naca23012
% Vinf = 26.0604;
% amb.rho=1.225;
% amb.visc = 1.79*10^-5;
% 
% alpharoot = 8; %[deg]
% polars = generate_polars(geometry, amb, Vinf, alpharoot);

%% NACA report data    - calculando CL e CD completo (com CD0) - Status: Compelto [x]

ARw = 6;
bw=10.9728;
lambdaw = 1;
airfoil_w = 14;
twist=0;
xw=0.1;
tail_arrang=3;
airfoil_ht=1;
AR_ht = 6;
b_ht=1.05;
lambda_ht=1;
W = 204;
SM = 0.05;
cf_c_ht=0.1;

p = [ARw, bw, lambdaw, airfoil_w, twist, xw, tail_arrang, airfoil_ht, AR_ht, b_ht, lambda_ht, W, SM, cf_c_ht];
aircraft = read_from_parameters(p);

% para não modificar a função
aircraft.wing.sweepLE=0;
aircraft.wing.i=0;

Vinf =26.0604;

[trim.wing.Clalpha_inf,trim.wing.CLalpha, trim.wing.alpha0, trim.wing.t_c, trim.wing.x_c_max] = airfoil_properties(aircraft.wing,aircraft.amb,Vinf);  
[trim.ht.Clalpha_inf,trim.ht.CLalpha, trim.ht.alpha0,trim.ht.t_c,trim.ht.x_c_max] = airfoil_properties(aircraft.ht,aircraft.amb,Vinf);

% Salvar propriedades na variáveis globais
Clalpha_inf_w = trim.wing.Clalpha_inf; 
CLalpha_w = trim.wing.CLalpha; 
alpha0_w = trim.wing.alpha0; 
t_c_w = trim.wing.t_c; 
x_c_max_w = trim.wing.x_c_max;

Clalpha_inf_ht = trim.ht.Clalpha_inf; 
CLalpha_ht = trim.ht.CLalpha; 
alpha0_ht = trim.ht.alpha0; 
t_c_ht = trim.ht.t_c; 
x_c_max_ht = trim.ht.x_c_max;



i=1;
for alpharoot = -8: 1 : 24 
       polars = generate_polars(aircraft.wing, aircraft.amb, Vinf, alpharoot,1);
       CL(i) = polars.CL;
       CDi(i) = polars.CDi;
       alpha(i)=alpharoot;
       i=i+1;
end       
       

[ CD0, CD0w, CD0ht, CD0vt, CD0fus ] = component_drag_CD0( aircraft, Vinf);

CD0w = CD0w*ones(1,length(CDi));
CD = CD0w+CDi;

plot(alpha,CD0w)
hold on
plot(alpha, CDi)
plot(alpha, CD)

xlabel('alpha')
ylabel('CD')
legend('CD0','CDi','CD');
grid on