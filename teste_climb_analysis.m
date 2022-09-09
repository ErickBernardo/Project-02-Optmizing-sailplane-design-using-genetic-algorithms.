%  Teste climb

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

modelA1=@fmodelA1;
modelA2=@fmodelA2;
modelB1=@fmodelB1;
modelB2=@fmodelB2;



bank_angle_ini=10;
bank_angle_fin=60;
d_bank_angle=10; % delta bank angle analisados [deg]

vki= 25;
vkf= 60;
dvk=5;

g=9.81;
rho=aircraft.amb.rho;

j=1;
Vsc_max = zeros(1,6);  % se nº de bank angles variar de 6 mudar limite
R_Vsc_max = zeros(1,6);
for bank_angle=bank_angle_ini:d_bank_angle:bank_angle_fin
    bank_angle = (pi/180)*bank_angle; %conversão [deg]>>[rad]    
    
    vk = [vki:dvk:vkf];
    CL = (2*aircraft.general.W*g)./(rho*aircraft.wing.S*cos(bank_angle)*(vk.^2));
    R= (vk.^2)./(g*tan(bank_angle)); 
    K = interp1(V_trim,K_int,vk,'PCHIP','extrap');
    CDi =  K.*(CL.^2);
    CD0 = interp1(Vcd0_int,CD0_int,vk,'PCHIP','extrap');
    CD = CDi + CD0;
    Vsc =  -(CD./((CL.*cos(bank_angle)).^1.5)).*(((2*aircraft.general.W*g)/(rho*aircraft.wing.S))^0.5);
    
    plot(vk,CDi)
    hold on
    
% %     plot(vk,CD0)
% %     hold on
% %     
% %     plot(vk,CD)
% %     hold on
    
    
    %interpolação
    R_interp = linspace(R(1),R(end),20);   
    %R_interp = linspace(15,R(i-1),50);
    
    Vsc_interp = interp1(R,Vsc,R_interp,'PCHIP','extrap');
        
    % localização do Vsc máximo
    [Vsc_max(j) , i_Vsc_max] = max(Vsc_interp);
    %bank_angle_max(j) = bank_angle;
    R_Vsc_max(j) = R_interp(i_Vsc_max);
    
    %gráfico Vs
%     figure
%     plot(R,Vsc,'*')
%     hold on
%     plot(R_interp,Vsc_interp)
%     xlabel('R')
%     ylabel('Vs')
%     grid on
    
    j=j+1;
    
end

% Desenvolvimento da curva de Vsc máximos X raios
R_interp = linspace(R_Vsc_max(j-1),R_Vsc_max(1),50);
V_lim_Vsc = interp1(R_Vsc_max,Vsc_max,R_interp,'PCHIP','extrap');

% Desenvolvimento da curva de Vc X raios
R_interp_ter = linspace(R_Vsc_max(j-1),150,50);
V_lim_Vsc_ter = interp1(R_Vsc_max,Vsc_max,R_interp_ter,'PCHIP','extrap');


%plot(R_interp_ter,V_lim_Vsc_ter,'--')



% calcular os Vcmax para os 4 modelos de térmicas
%A1
VT = modelA1(R_interp_ter); %retorna um vetor de VT da térmica nos raios de R_interp
Vc = VT+V_lim_Vsc_ter;
% Localização do Vc máximo
[climb.VcmaxA1 , i_Vcmax]=max(Vc);
climb.R_VcmaxA1 = R_interp_ter(i_Vcmax);
climb.V_lim_Vsc_terA1 = V_lim_Vsc_ter;
climb.VcA1 = Vc;
climb.R_interp_terA1 = R_interp_ter; 

%A2
VT = modelA2(R_interp_ter); %retorna um vetor de VT da térmica nos raios de R_interp
Vc = VT+V_lim_Vsc_ter;
% Localização do Vc máximo
[climb.VcmaxA2 , i_Vcmax]=max(Vc);
climb.R_VcmaxA2 = R_interp_ter(i_Vcmax);
climb.V_lim_Vsc_terA2 = V_lim_Vsc_ter;
climb.VcA2 = Vc;
climb.R_interp_terA2 = R_interp_ter; 

%B1
VT = modelB1(R_interp_ter); %retorna um vetor de VT da térmica nos raios de R_interp
Vc = VT+V_lim_Vsc_ter;
% Localização do Vc máximo
[climb.VcmaxB1 , i_Vcmax]=max(Vc);
climb.R_VcmaxB1 = R_interp_ter(i_Vcmax);
climb.V_lim_Vsc_terB1 = V_lim_Vsc_ter;
climb.VcB1 = Vc;
climb.R_interp_terB1 = R_interp_ter; 

%B2
VT = modelB2(R_interp_ter); %retorna um vetor de VT da térmica nos raios de R_interp
Vc = VT+V_lim_Vsc_ter;
% Localização do Vc máximo
[climb.VcmaxB2 , i_Vcmax]=max(Vc);
climb.R_VcmaxB2 = R_interp_ter(i_Vcmax);
climb.V_lim_Vsc_terB2 = V_lim_Vsc_ter;
climb.VcB2 = Vc;
climb.R_interp_terB2 = R_interp_ter; 

figure

VT = modelA1(climb.R_interp_terA1);
plot(climb.R_interp_terA1,climb.VcA1)
R_VcmaxA1 = climb.R_VcmaxA1;
VcmaxA1 = climb.VcmaxA1;

hold on

VT = modelA2(climb.R_interp_terA2);
plot(climb.R_interp_terA2,climb.VcA2)
R_VcmaxA2 = climb.R_VcmaxA2;
VcmaxA2 = climb.VcmaxA2;


VT = modelB1(climb.R_interp_terB1);
plot(climb.R_interp_terB1,climb.VcB1)
R_VcmaxB1 = climb.R_VcmaxB1;
VcmaxB1 = climb.VcmaxB1;


VT = modelB2(climb.R_interp_terB2);
plot(climb.R_interp_terB2,climb.VcB2)
R_VcmaxB2 = climb.R_VcmaxB2;
VcmaxB2 = climb.VcmaxB2;

legend('A1','A2','B1','B2')

plot(R_VcmaxA1,VcmaxA1,'s')
plot(R_VcmaxA2,VcmaxA2,'s')
plot(R_VcmaxB1,VcmaxB1,'s')
plot(R_VcmaxB2,VcmaxB2,'s')

xlabel('R [m]')
ylabel('Vc [m/s]')
grid on







%% teste análise grafica

% model = @fmodelB1;
% 
% bank_angle_ini=10;
% bank_angle_fin=60;
% vki= 10;
% vkf= 60;
% dvk=5;
% g=9.81;
% rho=aircraft.amb.rho;
% j=1;
% d_bank_angle=10; % delta bank angle analisados [deg]
%     
% for bank_angle=bank_angle_ini:d_bank_angle:bank_angle_fin
% bank_angle = (pi/180)*bank_angle; %conversão [deg]>>[rad]    
%     i=1; 
%     for vk = vki:dvk:vkf
%        
%         CL(i) = (2*aircraft.general.W*g)/(rho*aircraft.wing.S*cos(bank_angle)*(vk^2));
%         
%         R(i)= (vk^2)/(g*tan(bank_angle));
% 
%         % Consideração de uma polar de arrasto da aeronave: CD = CD0+KCl^2
%         % com K cte para determinado Reynolds, dependendo de parâmetros de
%         % geometria e Re.
%         % Utilizo o resultado do glide trimado no mesmo Reynolds para obter
%         % o valor de K.
%         %%trim(i) =  trim_analysis(aircraft,CL(i),vk); % alpha de trim na MAC / Trim analysis
%                
%         % Retorna o CD0 total da aeronave
%         %%[aerodynamic(i).CD0, aerodynamic(i).CD0w, aerodynamic(i).CD0ht, aerodynamic(i).CD0vt, aerodynamic(i).CD0fus ] = component_drag_CD0(aircraft,vk);
%         % Combine wing, ht and fuselage to build 'complete' aircraft CD = CD0+CDi_trim
%         %%aerodynamic(i).CD =  aerodynamic(i).CD0 + trim(i).CDi;
%                
%         % Vsc negativo para plotagem correta dos gráficos        
%         %%Vsc(i) =  -(aerodynamic(i).CD/((CL(i)*cos(bank_angle))^1.5))*(((2*aircraft.general.W*g)/(rho*aircraft.wing.S))^0.5);
%         
%         k = [0.022031 0.020929 0.020419 0.022328 0.028671];
%         CD_0 = [0.016406 0.016015 0.015771 0.015597 0.015463];
%         Vint = [20 30 40 50 60];
%         
%         CD0_int = interp1(Vint,CD_0,vk,'PCHIP','extrap');
%         k_int = interp1(Vint,k,vk,'PCHIP','extrap');        
%         CD(i) = CD0_int+k_int*(CL(i)^2);
%         
%         Vsc(i) =  -(CD(i)/((CL(i)*cos(bank_angle))^1.5))*(((2*aircraft.general.W*g)/(rho*aircraft.wing.S))^0.5);
% 
%         
%         i=i+1;        
%     end
%     
%     %interpolação
%     R_interp = linspace(R(1),R(i-1),20);   
%     %R_interp = linspace(15,R(i-1),50);
%     
%     Vsc_interp = interp1(R,Vsc,R_interp,'PCHIP','extrap');
%         
%     plot(R,Vsc,'+')
%     hold on
%     plot(R_interp,Vsc_interp)
%     xlabel('R [m]')
%     ylabel('Vsc [m/s]')
%     grid on
%     
%     % localização do Vsc máximo
%     [Vsc_max(j) , i_Vsc_max(j)] = max(Vsc_interp);
%     bank_angle_max(j) = bank_angle;
%     R_Vsc_max(j) = R_interp(i_Vsc_max(j));
%     
%     
%     plot(R_Vsc_max(j),Vsc_max(j),'*')
%     hold on
%     
%     j=j+1;
%     
% end
% 
% 
% % Desenvolvimento da curva de Vsc máximos X raios
% R_interp = linspace(R_Vsc_max(j-1),R_Vsc_max(1),50);
% %R_interp = linspace(15,R_Vsc_max(1),50);
% %R_interp = linspace(15,150,100);
% 
% 
% %V_lim_Vsc = interp1(R_Vsc_max,Vsc_max,R_interp,'cubic')
% %p=fit(R_Vsc_max',Vsc_max','poly4');
% %V_lim_Vsc=polyval([p.p1 p.p2 p.p3 p.p4 p.p5],R_interp);
% 
% V_lim_Vsc = interp1(R_Vsc_max,Vsc_max,R_interp,'PCHIP','extrap');
% 
% plot(R_interp,V_lim_Vsc,'--')
% 
% 
% 
% % Desenvolvimento da curva de Vc X raios
% 
% R_interp_ter = linspace(R_Vsc_max(j-1),150,50);
% V_lim_Vsc_ter = interp1(R_Vsc_max,Vsc_max,R_interp_ter,'PCHIP','extrap');
% VT = model(R_interp_ter); %retorna um vetor de VT da térmica nos raios de R_interp
% Vc = VT+V_lim_Vsc_ter;
% 
% figure
% plot(R_interp_ter,V_lim_Vsc_ter,'b')
% hold on
% plot(R_interp_ter,VT,'r')
% plot(R_interp_ter,Vc,'--')
% xlabel('R [m]')
% ylabel('V vertical [m/s]')
% legend('Vsc','Vt','Vc')
% grid on
% 
% % Localização do Vc máximo
% [climb.Vcmax , i_Vcmax]=max(Vc);
% climb.R_Vcmax = R_interp_ter(i_Vcmax);
% 
% plot(climb.R_Vcmax,climb.Vcmax,'s')

%% Teste da função ok [x]

% model = @fmodelB1;
% 
% climb  = climb_analysis_fast( aircraft, model );
% 
% 
% plot(climb.R_interp_ter,climb.V_lim_Vsc_ter,'b')
% hold on
% VT = model(climb.R_interp_ter);
% plot(climb.R_interp_ter,VT,'r')
% plot(climb.R_interp_ter,climb.Vc,'--')
% xlabel('R [m]')
% ylabel('V vertical [m/s]')
% legend('Vsc','Vt','Vc')
% grid on
% 
% plot(climb.R_Vcmax,climb.Vcmax,'s')


%% Comparação térmicas  ok[x]

% model = @fmodelA1;
% climb  = climb_analysis_fast( aircraft, model );
% VT = model(climb.R_interp_ter);
% plot(climb.R_interp_ter,climb.Vc)
% R_VcmaxA1 = climb.R_Vcmax;
% VcmaxA1 = climb.Vcmax;
% 
% hold on
% 
% model = @fmodelA2;
% climb  = climb_analysis_fast( aircraft, model );
% VT = model(climb.R_interp_ter);
% plot(climb.R_interp_ter,climb.Vc)
% R_VcmaxA2 = climb.R_Vcmax;
% VcmaxA2 = climb.Vcmax;
% 
% model = @fmodelB1;
% climb  = climb_analysis_fast( aircraft, model );
% VT = model(climb.R_interp_ter);
% plot(climb.R_interp_ter,climb.Vc)
% R_VcmaxB1 = climb.R_Vcmax;
% VcmaxB1 = climb.Vcmax;
% 
% model = @fmodelB2;
% climb  = climb_analysis_fast( aircraft, model );
% VT = model(climb.R_interp_ter);
% plot(climb.R_interp_ter,climb.Vc)
% R_VcmaxB2 = climb.R_Vcmax;
% VcmaxB2 = climb.Vcmax;
% 
% legend('A1','A2','B1','B2')
% 
% plot(R_VcmaxA1,VcmaxA1,'s')
% plot(R_VcmaxA2,VcmaxA2,'s')
% plot(R_VcmaxB1,VcmaxB1,'s')
% plot(R_VcmaxB2,VcmaxB2,'s')
% 
% xlabel('R [m]')
% ylabel('Vc [m/s]')
% grid on

%% Climb novo


% climb  = climb_analysis( aircraft, @fmodelA1, @fmodelA2, @fmodelB1, @fmodelB2 );
% 
% modelA1=@fmodelA1;
% modelA2=@fmodelA2;
% modelB1=@fmodelB1;
% modelB2=@fmodelB2;
% 
% 
% VT = modelA1(climb.R_interp_terA1);
% plot(climb.R_interp_terA1,climb.VcA1)
% R_VcmaxA1 = climb.R_VcmaxA1;
% VcmaxA1 = climb.VcmaxA1;
% 
% hold on
% 
% VT = modelA2(climb.R_interp_terA2);
% plot(climb.R_interp_terA2,climb.VcA2)
% R_VcmaxA2 = climb.R_VcmaxA2;
% VcmaxA2 = climb.VcmaxA2;
% 
% 
% VT = modelB1(climb.R_interp_terB1);
% plot(climb.R_interp_terB1,climb.VcB1)
% R_VcmaxB1 = climb.R_VcmaxB1;
% VcmaxB1 = climb.VcmaxB1;
% 
% 
% VT = modelB2(climb.R_interp_terB2);
% plot(climb.R_interp_terB2,climb.VcB2)
% R_VcmaxB2 = climb.R_VcmaxB2;
% VcmaxB2 = climb.VcmaxB2;
% 
% legend('A1','A2','B1','B2')
% 
% plot(R_VcmaxA1,VcmaxA1,'s')
% plot(R_VcmaxA2,VcmaxA2,'s')
% plot(R_VcmaxB1,VcmaxB1,'s')
% plot(R_VcmaxB2,VcmaxB2,'s')
% 
% xlabel('R [m]')
% ylabel('Vc [m/s]')
% grid on


