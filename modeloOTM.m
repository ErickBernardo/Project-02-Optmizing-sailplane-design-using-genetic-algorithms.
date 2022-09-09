% Teste f. trim_analysis

close all
clear all
clc

global ngeom 
global H
ngeom = 0;
H = 0;


global Vcd0_int;
global CD0_int;
global K_int;
global V_trim; 


flag = 6;

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


%% Teste da função -  Status: validado[x]

% g=9.81;
% i=1;
% for Vg=10:5:80
%     CL(i)=(2*aircraft.general.W*g)/(aircraft.amb.rho*aircraft.wing.S*(Vg^2));
%     trim =  trim_analysis(aircraft,CL(i),Vg);
%     CDi(i) = trim.CDi;
%     K(i) = CDi(i)/(CL(i)^2); % K da aeronave
%     i=i+1;
% end
% 
% V = [10:5:80];
% Vint = linspace(10,80,100);
% Kint = interp1(V,K,Vint,'PCHIP','extrap')
% CDiint = interp1(V,CDi,Vint,'PCHIP','extrap')
% 
% plot(V,K,'*')
% hold on
% plot(Vint,Kint)
% xlabel('V')
% ylabel('K')
% grid on
% 
% figure
% plot(V,CDi,'*')
% hold on
% plot(Vint,CDiint)
% xlabel('V')
% ylabel('CDi')
% grid on
% 
% i=1;
% for V=10:20:80
%     [ CD0(i), ~, ~, ~, ~ ] = component_drag_CD0( aircraft, V);
%     i=i+1;
% end
% 
% V = [10:20:80];
% CD0int = interp1(V,CD0,Vint,'PCHIP','extrap')
% 
% figure
% plot(V,CD0,'*')
% hold on
% plot(Vint,CD0int)
% xlabel('V')
% ylabel('CD0')
% grid on

%% teste função polares


polares( aircraft )

plot(Vcd0_int,CD0_int,'*')
 
figure
 
plot(V_trim,K_int,'*')
  