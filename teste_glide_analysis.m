% Teste glide_analysis


close all
clear all
clc

global H ngeom

H=0;
ngeom =0;


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

%%

global Vcd0_int;
global CD0_int;
global K_int;
global V_trim; 

polares(aircraft);

climb.VcmaxA1 = 0.2;
climb.VcmaxA2 = 1.2;
climb.VcmaxB1 = 5;
climb.VcmaxB2 = 15;


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

% Com uma Vc definida(velocidade máxima de climb na térmica), para cada velocidade de glide Vg, avalia-se a Vavg atingida.
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


plot(Vg_interp,Vs_interp)
hold on
plot(Vg,Vs,'*')
xlabel('Vg')
ylabel('Vs')
grid on


%A1
if climb.VcmaxA1 ~= 0
    Vavg_interpA1 = interp1(Vg,VavgA1,Vg_interp,'PCHIP','extrap');
    [glide.Vavg_maxA1 , i_Vavg_max ] = max(Vavg_interpA1); % Vavg máxima
    glide.Vg_Vavg_maxA1 = Vg_interp(i_Vavg_max);  % Vg para Vavg máxima
    glide.Vs_Vavg_maxA1 = Vs_interp(i_Vavg_max);  % Vs para Vavg máxima
    glide.aerodynamic.CDA1 = CD_interp(i_Vavg_max); % CD0 na Vavg máxima
    glide.aerodynamic.CLA1=CL_interp(i_Vavg_max);
end

plot([0 glide.Vg_Vavg_maxA1],[climb.VcmaxA1 glide.Vs_Vavg_maxA1])
plot(glide.Vavg_maxA1 ,0,'+')


% A2
if climb.VcmaxA2 ~= 0
    Vavg_interpA2 = interp1(Vg,VavgA2,Vg_interp,'PCHIP','extrap');
    [glide.Vavg_maxA2 , i_Vavg_max ] = max(Vavg_interpA2); % Vavg máxima
    glide.Vg_Vavg_maxA2 = Vg_interp(i_Vavg_max);  % Vg para Vavg máxima
    glide.Vs_Vavg_maxA2 = Vs_interp(i_Vavg_max);  % Vs para Vavg máxima
    glide.aerodynamic.CDA2 = CD_interp(i_Vavg_max); % CD0 na Vavg máxima
    glide.aerodynamic.CLA2=CL_interp(i_Vavg_max);
end

plot([0 glide.Vg_Vavg_maxA2],[climb.VcmaxA2 glide.Vs_Vavg_maxA2])
plot(glide.Vavg_maxA2 ,0,'+')


% B1
if climb.VcmaxB1 ~= 0
    Vavg_interpB1 = interp1(Vg,VavgB1,Vg_interp,'PCHIP','extrap');
    [glide.Vavg_maxB1 , i_Vavg_max ] = max(Vavg_interpB1); % Vavg máxima
    glide.Vg_Vavg_maxB1 = Vg_interp(i_Vavg_max);  % Vg para Vavg máxima
    glide.Vs_Vavg_maxB1 = Vs_interp(i_Vavg_max);  % Vs para Vavg máxima
    glide.aerodynamic.CDB1 = CD_interp(i_Vavg_max); % CD0 na Vavg máxima
    glide.aerodynamic.CLB1=CL_interp(i_Vavg_max);
end

plot([0 glide.Vg_Vavg_maxB1],[climb.VcmaxB1 glide.Vs_Vavg_maxB1])
plot(glide.Vavg_maxB1 ,0,'+')


% B2
if climb.VcmaxB2 ~= 0
    Vavg_interpB2 = interp1(Vg,VavgB2,Vg_interp,'PCHIP','extrap');
    [glide.Vavg_maxB2 , i_Vavg_max ] = max(Vavg_interpB2); % Vavg máxima
    glide.Vg_Vavg_maxB2 = Vg_interp(i_Vavg_max);  % Vg para Vavg máxima
    glide.Vs_Vavg_maxB2 = Vs_interp(i_Vavg_max);  % Vs para Vavg máxima
    glide.aerodynamic.CDB2 = CD_interp(i_Vavg_max); % CD0 na Vavg máxima
    glide.aerodynamic.CLB2=CL_interp(i_Vavg_max);
end


plot([0 glide.Vg_Vavg_maxB2],[climb.VcmaxB2 glide.Vs_Vavg_maxB2])
plot(glide.Vavg_maxB2 ,0,'+')


figure
plot(Vg_interp,Vavg_interpB2)
hold on
plot(glide.Vg_Vavg_maxB2,glide.Vavg_maxB2,'s')
figure
plot(Vg_interp,Vavg_interpB1)
hold on
plot(glide.Vg_Vavg_maxB1,glide.Vavg_maxB1,'s')
figure
plot(Vg_interp,Vavg_interpA1)
hold on
plot(glide.Vg_Vavg_maxA1,glide.Vavg_maxA1,'s')
figure
plot(Vg_interp,Vavg_interpA2)
hold on
plot(glide.Vg_Vavg_maxA2,glide.Vavg_maxA2,'s')


%% Avaliação gráfica


% Vcmax = 2.0186;
% 
% if Vcmax < 0
%    Vcmax=0; 
% end    
% 
% % Definição de um range de velocidade de glide
% Vgi=20;   %[m/s]
% Vgf=80;
% dVg=20;  % discretizar mais o intervalo de Vg
% g=9.81;
% 
% i=1;
% rho=aircraft.amb.rho; 
% 
% % Com uma Vc definida(velocidade máxima de climb na térmica), para cada velocidade de glide Vg, avalia-se a Vavg atingida.
% for Vg=Vgi:dVg:Vgf
% 
%     %CL de trimagem (equilibrio em planeio)
%     CL(i)=(2*aircraft.general.W*g)/(rho*aircraft.wing.S*(Vg^2));
%     
% %     trim(i) =  trim_analysis(aircraft,CL(i),Vg); % alpha de trim na MAC / Trim analysis
% %     
% %     % Retorna o CD0 total da aeronave
% %     [aerodynamic(i).CD0, aerodynamic(i).CD0w, aerodynamic(i).CD0ht, aerodynamic(i).CD0vt, aerodynamic(i).CD0fus ] = component_drag_CD0(aircraft,Vg);
% % 
% %     % Combine wing, ht and fuselage to build 'complete' aircraft CD = CD0+CDi_trim
% %     aerodynamic(i).CD =  aerodynamic(i).CD0 + trim(i).CDi;
% %     
% %     % Vs negativo para plotagem correta dos gráficos        
% %     Vs(i) =  -(aerodynamic(i).CD/((CL(i))^1.5))*(((2*aircraft.general.W*g)/(rho*aircarft.wing.S))^0.5);
% %     Vavg(i) = (Vg*Vcmax)/(Vcmax+abs(Vs(i)));
%     
%     k = [0.022031 0.020929 0.020419 0.022328 0.028671];
%     CD_0 = [0.016406 0.016015 0.015771 0.015597 0.015463];
%     Vint = [20 30 40 50 60];
% 
%     CD0_int = interp1(Vint,CD_0,Vg,'PCHIP','extrap');
%     k_int = interp1(Vint,k,Vg,'PCHIP','extrap');        
%     CD(i) = CD0_int+k_int*(CL(i)^2);
%     
%     % Vs negativo para plotagem correta dos gráficos        
%     Vs(i) =  -(CD(i)/((CL(i))^1.5))*(((2*aircraft.general.W*g)/(rho*aircraft.wing.S))^0.5);
%     Vavg(i) = (Vg*Vcmax)/(Vcmax+abs(Vs(i)));
%     
%     
%     
%     
%     i=i+1; 
% 
% end
% 
% Vg = [Vgi:dVg:Vgf];
% Vg_interp = linspace(Vgi,Vgf,150);
% 
% Vs_interp = interp1(Vg,Vs,Vg_interp,'PCHIP','extrap');
% Vavg_interp = interp1(Vg,Vavg,Vg_interp,'PCHIP','extrap');
% CL_interp = interp1(Vg,CL,Vg_interp,'PCHIP','extrap');
% CD_interp = interp1(Vg,CD,Vg_interp,'PCHIP','extrap');
% 
% [glide.Vavg_max , i_Vavg_max ] = max(Vavg_interp); % Vavg máxima
% glide.Vg_Vavg_max = Vg_interp(i_Vavg_max);  % Vg para Vavg máxima
% glide.Vs_Vavg_max = Vs_interp(i_Vavg_max);  % Vs para Vavg máxima
% glide.aerodynamic.CD = CD_interp(i_Vavg_max); % CD0 na Vavg máxima
% glide.aerodynamic.CL=CL_interp(i_Vavg_max);
% 
% 
% plot(Vg_interp,Vs_interp)
% hold on
% plot(Vg,Vs,'+')
% xlabel('Vg [m/s]')
% ylabel('Vy [m/s]')
% grid on
% 
% figure
% plot(Vg_interp,Vavg_interp)
% hold on
% plot(Vg,Vavg,'+')
% plot(glide.Vg_Vavg_max,glide.Vavg_max,'*')
% xlabel('Vg [m/s]')
% ylabel('Vavg [m/s]')
% grid on
% 
% figure
% plot(Vg_interp,CL_interp)
% hold on
% plot(Vg,CL,'+')
% xlabel('Vg [m/s]')
% ylabel('CL')
% grid on
% 
% figure
% plot(Vg_interp,CD_interp)
% hold on
% plot(Vg,CD,'+')
% xlabel('Vg [m/s]')
% ylabel('CD')
% grid on
% 
% figure
% plot(Vg_interp,Vs_interp)
% hold on
% % pontos
% plot(0,Vcmax,'*')
% plot(glide.Vavg_max,0,'+')
% plot(glide.Vg_Vavg_max,glide.Vs_Vavg_max,'s')
% %reta
% plot([0 glide.Vg_Vavg_max],[Vcmax  glide.Vs_Vavg_max],'--')
% xlabel('Vg [m/s]')
% ylabel('Vy [m/s]')
% grid on
% 
% figure
% plot(Vg_interp,CL_interp./CD_interp)
% hold on
% xlabel('Vg [m/s]')
% ylabel('CL/CD')
% grid on
% 
% 
% teste = glide_analysis_fast(aircraft, Vcmax);

%% Nova glide_analysis

% climb.VcmaxA1 = 0.2;
% climb.VcmaxA2 = 1.2;
% climb.VcmaxB1 = 5;
% climb.VcmaxB2 = 15;
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% if climb.VcmaxA1 < 0 || climb.VcmaxA1 == 0
%    climb.VcmaxA1=0; 
%    glide.Vavg_maxA1 = 0;
% end 
% if climb.VcmaxA2 < 0 || climb.VcmaxA2 == 0
%     climb.VcmaxA2=0;
%     glide.Vavg_maxA2 = 0;
% end 
% if climb.VcmaxB1 < 0 || climb.VcmaxB1 == 0
%     climb.VcmaxB1=0;
%     glide.Vavg_maxB1 = 0;
% end 
% if climb.VcmaxB2 < 0 || climb.VcmaxB2 == 0
%     climb.VcmaxB2=0;
%     glide.Vavg_maxB2 = 0;
% end 
% 
% % Definição de um range de velocidade de glide
% Vgi=20;   %[m/s]
% Vgf=80;
% dVg=20;  % discretizar mais o intervalo de Vg
% g=9.81;
% 
% i=1;
% rho=aircraft.amb.rho; 
% 
% % Com uma Vc definida(velocidade máxima de climb na térmica), para cada velocidade de glide Vg, avalia-se a Vavg atingida.
% for Vg=Vgi:dVg:Vgf
% 
%     %CL de trimagem (equilibrio em planeio)
%     CL(i)=(2*aircraft.general.W*g)/(rho*aircraft.wing.S*(Vg^2));
% 
% %     trim(i) =  trim_analysis(aircraft,CL(i),Vg); % alpha de trim na MAC / Trim analysis
% %     
% %     % Retorna o CD0 total da aeronave
% %     [aerodynamic(i).CD0, aerodynamic(i).CD0w, aerodynamic(i).CD0ht, aerodynamic(i).CD0vt, aerodynamic(i).CD0fus ] = component_drag_CD0(aircraft,Vg);
% % 
% %     % Combine wing, ht and fuselage to build 'complete' aircraft CD = CD0+CDi_trim
% %     aerodynamic(i).CD =  aerodynamic(i).CD0 + trim(i).CDi;
% %     
% %     % Vs negativo para plotagem correta dos gráficos        
% %     Vs(i) =  -(aerodynamic(i).CD/((CL(i))^1.5))*(((2*aircraft.general.W*g)/(rho*aircarft.wing.S))^0.5);
% %     Vavg(i) = (Vg*Vcmax)/(Vcmax+abs(Vs(i)));
% 
%     k = [0.022031 0.020929 0.020419 0.022328 0.028671];
%     CD_0 = [0.016406 0.016015 0.015771 0.015597 0.015463];
%     Vint = [20 30 40 50 60];
% 
%     CD0_int = interp1(Vint,CD_0,Vg,'PCHIP','extrap');
%     k_int = interp1(Vint,k,Vg,'PCHIP','extrap');        
%     CD(i) = CD0_int+k_int*(CL(i)^2);
% 
%     % Vs negativo para plotagem correta dos gráficos        
%     %Vs(i) =  -(CD(i)/((CL(i))^1.5))*(((2*aircraft.general.W*g)/(rho*aircraft.wing.S))^0.5);
%      Vs(i) =  -(CD(i)/CL(i))*Vg;
%     
%     
%     %
%     VavgA1(i) = (Vg*climb.VcmaxA1)/(climb.VcmaxA1+abs(Vs(i)));
%     VavgA2(i) = (Vg*climb.VcmaxA2)/(climb.VcmaxA2+abs(Vs(i)));
%     VavgB1(i) = (Vg*climb.VcmaxB1)/(climb.VcmaxB1+abs(Vs(i)));
%     VavgB2(i) = (Vg*climb.VcmaxB2)/(climb.VcmaxB2+abs(Vs(i)));
%     
%     i=i+1; 
% 
% end
% 
% Vg = [Vgi:dVg:Vgf];
% Vg_interp = linspace(Vgi,Vgf,800);
% 
% Vs_interp = interp1(Vg,Vs,Vg_interp,'PCHIP','extrap');
% CL_interp = interp1(Vg,CL,Vg_interp,'PCHIP','extrap');
% CD_interp = interp1(Vg,CD,Vg_interp,'PCHIP','extrap');
% 
% %A1
% if climb.VcmaxA1 ~= 0
%     Vavg_interpA1 = interp1(Vg,VavgA1,Vg_interp,'PCHIP','extrap');
%     [glide.Vavg_maxA1 , i_Vavg_max ] = max(Vavg_interpA1); % Vavg máxima
% %     glide.Vg_Vavg_maxA1 = Vg_interp(i_Vavg_max);  % Vg para Vavg máxima
% %     glide.Vs_Vavg_maxA1 = Vs_interp(i_Vavg_max);  % Vs para Vavg máxima
% %     glide.aerodynamic.CDA1 = CD_interp(i_Vavg_max); % CD0 na Vavg máxima
% %     glide.aerodynamic.CLA1=CL_interp(i_Vavg_max);
% end
% 
% % A2
% if climb.VcmaxA2 ~= 0
%     Vavg_interpA2 = interp1(Vg,VavgA2,Vg_interp,'PCHIP','extrap');
%     [glide.Vavg_maxA2 , i_Vavg_max ] = max(Vavg_interpA2); % Vavg máxima
% %     glide.Vg_Vavg_maxA2 = Vg_interp(i_Vavg_max);  % Vg para Vavg máxima
% %     glide.Vs_Vavg_maxA2 = Vs_interp(i_Vavg_max);  % Vs para Vavg máxima
% %     glide.aerodynamic.CDA2 = CD_interp(i_Vavg_max); % CD0 na Vavg máxima
% %     glide.aerodynamic.CLA2=CL_interp(i_Vavg_max);
% end
% 
% % B1
% if climb.VcmaxB1 ~= 0
%     Vavg_interpB1 = interp1(Vg,VavgB1,Vg_interp,'PCHIP','extrap');
%     [glide.Vavg_maxB1 , i_Vavg_max ] = max(Vavg_interpB1); % Vavg máxima
% %     glide.Vg_Vavg_maxB1 = Vg_interp(i_Vavg_max);  % Vg para Vavg máxima
% %     glide.Vs_Vavg_maxB1 = Vs_interp(i_Vavg_max);  % Vs para Vavg máxima
% %     glide.aerodynamic.CDB1 = CD_interp(i_Vavg_max); % CD0 na Vavg máxima
% %     glide.aerodynamic.CLB1=CL_interp(i_Vavg_max);
% end
% 
% % B2
% if climb.VcmaxB2 ~= 0
%     Vavg_interpB2 = interp1(Vg,VavgB2,Vg_interp,'PCHIP','extrap');
%     [glide.Vavg_maxB2 , i_Vavg_max ] = max(Vavg_interpB2); % Vavg máxima
% %     glide.Vg_Vavg_maxB2 = Vg_interp(i_Vavg_max);  % Vg para Vavg máxima
% %     glide.Vs_Vavg_maxB2 = Vs_interp(i_Vavg_max);  % Vs para Vavg máxima
% %     glide.aerodynamic.CDB2 = CD_interp(i_Vavg_max); % CD0 na Vavg máxima
% %     glide.aerodynamic.CLB2=CL_interp(i_Vavg_max);
% end
% 
% figure
% plot(Vg_interp,Vs_interp)
% hold on
% % pontos
% plot(0,climb.VcmaxA1,'*')
% plot(glide.Vavg_maxA1,0,'+')
% plot(glide.Vg_Vavg_maxA1,glide.Vs_Vavg_maxA1,'s')
% %reta
% plot([0 glide.Vg_Vavg_maxA1],[climb.VcmaxA1  glide.Vs_Vavg_maxA1],'--')
% xlabel('Vg [m/s]')
% ylabel('Vy [m/s]')
% grid on
% 
% figure
% plot(Vg_interp,Vs_interp)
% hold on
% % pontos
% plot(0,climb.VcmaxA2,'*')
% plot(glide.Vavg_maxA2,0,'+')
% plot(glide.Vg_Vavg_maxA2,glide.Vs_Vavg_maxA2,'s')
% %reta
% plot([0 glide.Vg_Vavg_maxA2],[climb.VcmaxA2  glide.Vs_Vavg_maxA2],'--')
% xlabel('Vg [m/s]')
% ylabel('Vy [m/s]')
% grid on
% 
% 
% figure
% plot(Vg_interp,Vs_interp)
% hold on
% % pontos
% plot(0,climb.VcmaxB1,'*')
% plot(glide.Vavg_maxB1,0,'+')
% plot(glide.Vg_Vavg_maxB1,glide.Vs_Vavg_maxB1,'s')
% %reta
% plot([0 glide.Vg_Vavg_maxB1],[climb.VcmaxB1  glide.Vs_Vavg_maxB1],'--')
% xlabel('Vg [m/s]')
% ylabel('Vy [m/s]')
% grid on
% 
% figure
% plot(Vg_interp,Vs_interp)
% hold on
% % pontos
% plot(0,climb.VcmaxB2,'*')
% plot(glide.Vavg_maxB2,0,'+')
% plot(glide.Vg_Vavg_maxB2,glide.Vs_Vavg_maxB2,'s')
% %reta
% plot([0 glide.Vg_Vavg_maxB2],[climb.VcmaxB2  glide.Vs_Vavg_maxB2],'--')
% xlabel('Vg [m/s]')
% ylabel('Vy [m/s]')
% grid on
% 
% figure
% plot(Vg_interp,Vavg_interpA1)
% hold on
% plot(Vg_interp,Vavg_interpA2)
% plot(Vg_interp,Vavg_interpB1)
% plot(Vg_interp,Vavg_interpB2)
% plot(glide.Vg_Vavg_maxA1,glide.Vavg_maxA1,'*')
% plot(glide.Vg_Vavg_maxA2,glide.Vavg_maxA2,'*')
% plot(glide.Vg_Vavg_maxB1,glide.Vavg_maxB1,'*')
% plot(glide.Vg_Vavg_maxB2,glide.Vavg_maxB2,'*')




%% teste função

% climb.VcmaxA1 = 0.2;
% climb.VcmaxA2 = 1.2;
% climb.VcmaxB1 = 5;
% climb.VcmaxB2 = 15;
% 
% % menos de 1 min de execução
% 
% glideteste = glide_analysis(aircraft, climb)

