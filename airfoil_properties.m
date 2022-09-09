function [Clalpha_inf,CLalpha, alpha0, t_c, x_c_max] = airfoil_properties(geometry,amb,Vinf)
% Status: Programado [x] Verificado [x] Validado [x]
% Objetivo: Retornar dados do BD de aerofólios na MAC

global read_airfoil perfil

Re_MAC= (amb.rho*Vinf*geometry.MAC)/amb.visc;

%% Identificação do aerofólio e load do BD

if read_airfoil == 1

   if geometry.airfoil == 1
           load('airfoildata\naca0012.mat');
           perfil = naca0012;
    end
    if geometry.airfoil == 2
           load('airfoildata\s9026.mat');
           perfil = s9026;
    end
    if geometry.airfoil == 3
           load('airfoildata\e662.mat');
           perfil = e662;
    end
    if geometry.airfoil == 4
           load('airfoildata\e403.mat');
           perfil = e403;
    end
    if geometry.airfoil == 5
           load('airfoildata\e583.mat');
           perfil = e583;
    end
    if geometry.airfoil == 6
           load('airfoildata\e603.mat');
           perfil = e603;
    end
%     if geometry.airfoil == 7
%            load('airfoildata\Cm0\e657.mat');
%            data = e657;
%     end
%     if geometry.airfoil == 8
%            load('airfoildata\Cm0\ea81006.mat');
%            data = ea81006;
%     end
%     if geometry.airfoil == 9
%            load('airfoildata\Cm0\fx66s196.mat');
%            data = fx66s196;
%     end
%     if geometry.airfoil == 10
%            load('airfoildata\Cm0\fx79k144.mat');
%            data = fx79k144;
%     end
    if geometry.airfoil == 7
           load('airfoildata\fx61163.mat');
           perfil = fx61163;
    end
    if geometry.airfoil == 8
           load('airfoildata\fxs02196.mat');
           perfil = fxs02196;
    end
%     if geometry.airfoil == 13
%            load('airfoildata\Cm0\hq359.mat');
%            data = hq359;
%     end
    if geometry.airfoil == 9
           load('airfoildata\naca23012.mat');
           perfil = naca23012;
    end
    if geometry.airfoil == 10
           load('airfoildata\naca633618.mat');
           perfil = naca633618;
    end
    if geometry.airfoil == 11
           load('airfoildata\sm701.mat');
           perfil = sm701;
    end

end    
    
read_airfoil = 0; 

%% Read file

% Input Re específicos
%airfoil_Re = xlsread(filename,sheet,'A2:A11');   %%%
Re = 500000; 
for i=1:1:10
   airfoil_Re(i)=Re;
   Re=Re+1000000;
end    

airfoil_Clalpha = perfil(:,2);

airfoil_alpha0 = perfil(:,3);

airfoil_t_c = perfil(1,4); % valor cte

airfoil_x_c_max = perfil(1,5); % valor cte


for i = 1:1:length(airfoil_Re);
  erro(i) = abs(Re_MAC-airfoil_Re(i))/Re_MAC;
end

% Localizar os Re mais próximos do BD
[erro,j] = min(erro);

%Propriedades MAC
Clalpha_inf = airfoil_Clalpha(j);
CLalpha = Clalpha_inf / (1 + (Clalpha_inf/(pi*geometry.AR))); % aproximaçao eliptica > ok para proj. conceitual.
alpha0 = airfoil_alpha0(j);
t_c = airfoil_t_c;
x_c_max = airfoil_x_c_max;


end

