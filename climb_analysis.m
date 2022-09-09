function [ climb ] = climb_analysis( aircraft, modelA1,modelA2,modelB1,modelB2 )
% Status: Programado [x] Verificado [x] Validado [x]
% Resolver: Só consigo identificar o bank angle de máximo Vc gráficamente,
% pq perco a informação na interpolação, se o ponto de máximo for entre
% dois pontos calculados na discretização.

global Vcd0_int;
global CD0_int;
global K_int;
global V_trim; 

bank_angle_ini=10;
bank_angle_fin=60;
d_bank_angle=10; % delta bank angle analisados [deg]

vki= 10;
vkf= 60;
dvk=15;

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
    
    
    %interpolação
    R_interp = linspace(R(1),R(end),20);   
    %R_interp = linspace(15,R(i-1),50);
    
    Vsc_interp = interp1(R,Vsc,R_interp,'PCHIP','extrap');
        
    % localização do Vsc máximo
    [Vsc_max(j) , i_Vsc_max] = max(Vsc_interp);
    %bank_angle_max(j) = bank_angle;
    R_Vsc_max(j) = R_interp(i_Vsc_max);
       
    j=j+1;
    
end

% Desenvolvimento da curva de Vsc máximos X raios
R_interp = linspace(R_Vsc_max(j-1),R_Vsc_max(1),50);
V_lim_Vsc = interp1(R_Vsc_max,Vsc_max,R_interp,'PCHIP','extrap');

% Desenvolvimento da curva de Vc X raios
R_interp_ter = linspace(R_Vsc_max(j-1),150,50);
V_lim_Vsc_ter = interp1(R_Vsc_max,Vsc_max,R_interp_ter,'PCHIP','extrap');


% calcular os Vcmax para os 4 modelos de térmicas
%A1
VT = modelA1(R_interp_ter); %retorna um vetor de VT da térmica nos raios de R_interp
Vc = VT+V_lim_Vsc_ter;
% Localização do Vc máximo
[climb.VcmaxA1 , i_Vcmax]=max(Vc);
% climb.R_VcmaxA1 = R_interp_ter(i_Vcmax);
% climb.V_lim_Vsc_terA1 = V_lim_Vsc_ter;
% climb.VcA1 = Vc;
% climb.R_interp_terA1 = R_interp_ter; 

%A2
VT = modelA2(R_interp_ter); %retorna um vetor de VT da térmica nos raios de R_interp
Vc = VT+V_lim_Vsc_ter;
% Localização do Vc máximo
[climb.VcmaxA2 , i_Vcmax]=max(Vc);
% climb.R_VcmaxA2 = R_interp_ter(i_Vcmax);
% climb.V_lim_Vsc_terA2 = V_lim_Vsc_ter;
% climb.VcA2 = Vc;
% climb.R_interp_terA2 = R_interp_ter; 

%B1
VT = modelB1(R_interp_ter); %retorna um vetor de VT da térmica nos raios de R_interp
Vc = VT+V_lim_Vsc_ter;
% Localização do Vc máximo
[climb.VcmaxB1 , i_Vcmax]=max(Vc);
% climb.R_VcmaxB1 = R_interp_ter(i_Vcmax);
% climb.V_lim_Vsc_terB1 = V_lim_Vsc_ter;
% climb.VcB1 = Vc;
% climb.R_interp_terB1 = R_interp_ter; 

%B2
VT = modelB2(R_interp_ter); %retorna um vetor de VT da térmica nos raios de R_interp
Vc = VT+V_lim_Vsc_ter;
% Localização do Vc máximo
[climb.VcmaxB2 , i_Vcmax]=max(Vc);
% climb.R_VcmaxB2 = R_interp_ter(i_Vcmax);
% climb.V_lim_Vsc_terB2 = V_lim_Vsc_ter;
% climb.VcB2 = Vc;
% climb.R_interp_terB2 = R_interp_ter; 



end








