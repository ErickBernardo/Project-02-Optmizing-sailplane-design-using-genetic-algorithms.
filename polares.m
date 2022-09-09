function [ ] = polares( aircraft )
% Criar polares de trimagem e de CD0

global Vcd0_int;
global CD0_int;
global K_int;
global V_trim; 


g=9.81;

% Criar variáveis de interpolação de trimagem
Vtrimi=10;
dVtrim=10;
Vtrimf=80;

i=1;
K_int = zeros(1,round((Vtrimf-Vtrimi)/dVtrim));
for Vtrim=Vtrimi:dVtrim:Vtrimf
    CL=(2*aircraft.general.W*g)/(aircraft.amb.rho*aircraft.wing.S*(Vtrim^2));
    trim =  trim_analysis(aircraft,CL,Vtrim);
    CDi = trim.CDi;
    K_int(i) = CDi/(CL^2); % K da aeronave
    i=i+1;
end

V_trim = [Vtrimi:dVtrim:Vtrimf];


Vcd0i=10;
dVcd0=10;
Vcd0f=80;

i=1;
CD0_int = zeros(1,round((Vcd0f-Vcd0i)/dVcd0));
for Vcd0=Vcd0i:dVcd0:Vcd0f
    [ CD0_int(i), ~, ~, ~, ~ ] = component_drag_CD0( aircraft, Vcd0);
    i=i+1;
end

Vcd0_int = [Vtrimi:dVtrim:Vtrimf];


end

