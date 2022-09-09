function [ glide ] = glide_analysis( aircraft, climb )
% Status: Programado [x] Verificado [x] Validado [x]
% Objetivo: calcular a Vavg máxima no glide, uma vez conhecido o Vc ótimo no
% climb

global Vcd0_int;
global CD0_int;
global K_int;
global V_trim; 


if climb.VcmaxA1 < 0 || climb.VcmaxA1 == 0
   climb.VcmaxA1=0; 
   glide.Vavg_maxA1 = 0;
end 
if climb.VcmaxA2 < 0 || climb.VcmaxA2 == 0
    climb.VcmaxA2=0;
    glide.Vavg_maxA2 = 0;
end 
if climb.VcmaxB1 < 0 || climb.VcmaxB1 == 0
    climb.VcmaxB1=0;
    glide.Vavg_maxB1 = 0;
end 
if climb.VcmaxB2 < 0 || climb.VcmaxB2 == 0
    climb.VcmaxB2=0;
    glide.Vavg_maxB2 = 0;
end 

% Definição de um range de velocidade de glide
Vgi=20;   %[m/s]
Vgf=80;
dVg=20;  % discretizar mais o intervalo de Vg
g=9.81;

%i=1;
rho=aircraft.amb.rho; 

Vg = [Vgi:dVg:Vgf];
CL = (2*aircraft.general.W*g)./(rho*aircraft.wing.S*(Vg.^2));
K = interp1(V_trim,K_int,Vg,'PCHIP','extrap');
CDi =  K.*(CL.^2);
CD0 = interp1(Vcd0_int,CD0_int,Vg,'PCHIP','extrap');
CD = CDi + CD0;
Vs =-(CD./CL).*Vg;

% Vavg para cada térmica
VavgA1 = (Vg.*climb.VcmaxA1)./(climb.VcmaxA1+abs(Vs));
VavgA2 = (Vg.*climb.VcmaxA2)./(climb.VcmaxA2+abs(Vs));
VavgB1 = (Vg.*climb.VcmaxB1)./(climb.VcmaxB1+abs(Vs));
VavgB2 = (Vg.*climb.VcmaxB2)./(climb.VcmaxB2+abs(Vs));


Vg_interp = linspace(Vgi,Vgf,800);

Vs_interp = interp1(Vg,Vs,Vg_interp,'PCHIP','extrap');
CL_interp = interp1(Vg,CL,Vg_interp,'PCHIP','extrap');
CD_interp = interp1(Vg,CD,Vg_interp,'PCHIP','extrap');

%A1
if climb.VcmaxA1 ~= 0
    Vavg_interpA1 = interp1(Vg,VavgA1,Vg_interp,'PCHIP','extrap');
    [glide.Vavg_maxA1 , i_Vavg_max ] = max(Vavg_interpA1); % Vavg máxima
%     glide.Vg_Vavg_maxA1 = Vg_interp(i_Vavg_max);  % Vg para Vavg máxima
%     glide.Vs_Vavg_maxA1 = Vs_interp(i_Vavg_max);  % Vs para Vavg máxima
%     glide.aerodynamic.CDA1 = CD_interp(i_Vavg_max); % CD0 na Vavg máxima
%     glide.aerodynamic.CLA1=CL_interp(i_Vavg_max);
end

% A2
if climb.VcmaxA2 ~= 0
    Vavg_interpA2 = interp1(Vg,VavgA2,Vg_interp,'PCHIP','extrap');
    [glide.Vavg_maxA2 , i_Vavg_max ] = max(Vavg_interpA2); % Vavg máxima
%     glide.Vg_Vavg_maxA2 = Vg_interp(i_Vavg_max);  % Vg para Vavg máxima
%     glide.Vs_Vavg_maxA2 = Vs_interp(i_Vavg_max);  % Vs para Vavg máxima
%     glide.aerodynamic.CDA2 = CD_interp(i_Vavg_max); % CD0 na Vavg máxima
%     glide.aerodynamic.CLA2=CL_interp(i_Vavg_max);
end

% B1
if climb.VcmaxB1 ~= 0
    Vavg_interpB1 = interp1(Vg,VavgB1,Vg_interp,'PCHIP','extrap');
    [glide.Vavg_maxB1 , i_Vavg_max ] = max(Vavg_interpB1); % Vavg máxima
%     glide.Vg_Vavg_maxB1 = Vg_interp(i_Vavg_max);  % Vg para Vavg máxima
%     glide.Vs_Vavg_maxB1 = Vs_interp(i_Vavg_max);  % Vs para Vavg máxima
%     glide.aerodynamic.CDB1 = CD_interp(i_Vavg_max); % CD0 na Vavg máxima
%     glide.aerodynamic.CLB1=CL_interp(i_Vavg_max);
end

% B2
if climb.VcmaxB2 ~= 0
    Vavg_interpB2 = interp1(Vg,VavgB2,Vg_interp,'PCHIP','extrap');
    [glide.Vavg_maxB2 , i_Vavg_max ] = max(Vavg_interpB2); % Vavg máxima
%     glide.Vg_Vavg_maxB2 = Vg_interp(i_Vavg_max);  % Vg para Vavg máxima
%     glide.Vs_Vavg_maxB2 = Vs_interp(i_Vavg_max);  % Vs para Vavg máxima
%     glide.aerodynamic.CDB2 = CD_interp(i_Vavg_max); % CD0 na Vavg máxima
%     glide.aerodynamic.CLB2=CL_interp(i_Vavg_max);
end


end

