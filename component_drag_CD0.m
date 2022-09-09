function [ CD0, CD0w, CD0ht, CD0vt, CD0fus ] = component_drag_CD0( aircraft, Vinf)
% Status: Programado [x] Verificado [x] Validado [x]
% Objetivo: Cálculo do CD0 total
% Ref. Raymer - Component Buildup Method

global Clalpha_inf_w CLalpha_w alpha0_w t_c_w x_c_max_w;
global Clalpha_inf_ht CLalpha_ht alpha0_ht t_c_ht x_c_max_ht;

%% Wing

% de escoamento laminar
lam=0.2;
k=0.052*10^(-5); % [m] - smooth molded composite
% área molhada
Swetw = 2*aircraft.wing.S;

% Cf
Re = (aircraft.amb.rho*Vinf*aircraft.wing.MAC)/aircraft.amb.visc;
Cf_lam = 1.328/sqrt(Re);
Re_cutoff = 38.21*(aircraft.wing.MAC/k)^1.053;
Re=min(Re,Re_cutoff);
Cf_turb = 0.455/(((log10(Re))^2.58)*((1+0.144*(Vinf/aircraft.amb.a)^2)^0.65));
Cfw =lam*Cf_lam+(1-lam)*Cf_turb;

% FF
t_c = t_c_w;
x_c_max = x_c_max_w;
%[~,~, ~, t_c, x_c_max] = airfoil_properties(aircraft.wing,aircraft.amb,Vinf,flag);
% ângulo no ponto de máxima espessura
sweepMAX = atan((0.5*aircraft.wing.span*tan(aircraft.wing.sweepLE*(pi/180))-x_c_max*aircraft.wing.cr+x_c_max*aircraft.wing.cr*aircraft.wing.lambda)/(0.5*aircraft.wing.span));
FFw=(1+(0.6/x_c_max)*(t_c)+100*(t_c)^4)*((1.34*(Vinf/aircraft.amb.a)^0.18)*(cos(sweepMAX))^0.28);

% Q
% asa média
Qw=1;

CD0w = (Cfw*FFw*Qw*Swetw)/aircraft.wing.S;


%% HT

% de escoamento laminar
lam=0.2;
k=0.052*10^(-5); % [m] - smooth molded composite
% área molhada
Swetht = 2*aircraft.ht.S;

% Cf
Re = (aircraft.amb.rho*Vinf*aircraft.ht.MAC)/aircraft.amb.visc;
Cf_lam = 1.328/sqrt(Re);
Re_cutoff = 38.21*(aircraft.ht.MAC/k)^1.053;
Re=min(Re,Re_cutoff);
Cf_turb = 0.455/(((log10(Re))^2.58)*((1+0.144*(Vinf/aircraft.amb.a)^2)^0.65));
Cfht =lam*Cf_lam+(1-lam)*Cf_turb;

% FF
t_c = t_c_ht;
x_c_max = x_c_max_ht;
%[~,~, ~, t_c, x_c_max] = airfoil_properties(aircraft.ht,aircraft.amb,Vinf,flag);
% ângulo no ponto de máxima espessura
sweepMAX = atan((0.5*aircraft.ht.span*tan(aircraft.ht.sweepLE*(pi/180))-x_c_max*aircraft.ht.cr+x_c_max*aircraft.ht.cr*aircraft.ht.lambda)/(0.5*aircraft.ht.span));
FFht=(1+(0.6/x_c_max)*(t_c)+100*(t_c)^4)*((1.34*(Vinf/aircraft.amb.a)^0.18)*(cos(sweepMAX))^0.28);

% Q
% tail
Qht=1.04;

CD0ht = (Cfht*FFht*Qht*Swetht)/aircraft.wing.S;


%% VT

% de escoamento laminar
lam=0.2;
k=0.052*10^(-5); % [m] - smooth molded composite
% área molhada
Swetvt = 2*aircraft.vt.S;

% Cf
Re = (aircraft.amb.rho*Vinf*aircraft.vt.MAC)/aircraft.amb.visc;
Cf_lam = 1.328/sqrt(Re);
Re_cutoff = 38.21*(aircraft.vt.MAC/k)^1.053;
Re=min(Re,Re_cutoff);
Cf_turb = 0.455/(((log10(Re))^2.58)*((1+0.144*(Vinf/aircraft.amb.a)^2)^0.65));
Cfvt =lam*Cf_lam+(1-lam)*Cf_turb;

% FF
% naca 001 fixo
t_c = aircraft.vt.t_c;
x_c_max = aircraft.vt.x_c_max; 
%[~,~, ~, t_c, x_c_max] = airfoil_properties(aircraft.vt,aircraft.amb,Vinf,flag);
% ângulo no ponto de máxima espessura
sweepMAX = atan((aircraft.vt.span*tan(aircraft.vt.sweepLE*(pi/180))-x_c_max*aircraft.vt.cr+x_c_max*aircraft.vt.cr*aircraft.vt.lambda)/(aircraft.vt.span));
FFvt=(1+(0.6/x_c_max)*(t_c)+100*(t_c)^4)*((1.34*(Vinf/aircraft.amb.a)^0.18)*(cos(sweepMAX))^0.28);

% Q
% tail
Qvt=1.04;

CD0vt = (Cfvt*FFvt*Qvt*Swetvt)/aircraft.wing.S;

%% Fuselage

% de escoamento laminar
lam=0.2;
k=0.052*10^(-5); % [m] - smooth molded composite
% área molhada
pos=aircraft.wing.positionx;
Swetfus = pi*aircraft.fuselage.radius*sqrt(pos^2+aircraft.fuselage.radius^2)+pi*aircraft.fuselage.radius*sqrt((aircraft.fuselage.Lf-pos)^2+aircraft.fuselage.radius^2);  

% Cf
Re = (aircraft.amb.rho*Vinf*aircraft.fuselage.Lf)/aircraft.amb.visc;
Cf_lam = 1.328/sqrt(Re);
Re_cutoff = 38.21*(aircraft.fuselage.Lf/k)^1.053;
Re=min(Re,Re_cutoff);
Cf_turb = 0.455/(((log10(Re))^2.58)*((1+0.144*(Vinf/aircraft.amb.a)^2)^0.65));
Cffus =lam*Cf_lam+(1-lam)*Cf_turb;

% FF
f = (aircraft.fuselage.Lf)/sqrt((4/pi)*(pi*aircraft.fuselage.radius^2));
FFfus=1+60/(f^3)+f/400;

% Q
% tail
Qfus=1;

CD0fus = (Cffus*FFfus*Qfus*Swetfus)/aircraft.wing.S;

CDwet = CD0w+CD0ht+CD0vt+CD0fus;

%% CDmisc
% compensado no final
CDmisc=0;

%% CDL&P
% compensado no final
CDLP=0;

%% CD0 total

CD0 = CDwet + CDmisc + CDLP;
CD0=1.05*CD0;

end

