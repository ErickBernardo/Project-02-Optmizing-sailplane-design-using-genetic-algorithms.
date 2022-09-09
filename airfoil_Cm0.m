function Cm0 = airfoil_Cm0(geometry,amb,Vinf,alpha_w)
% Status: Programado [x] Verificado [x] Validado [x]
% Objetivo: Retornar o Cm0 do aerofólio no AoA alpha_w

global data  readCm

Re_MAC= (amb.rho*Vinf*geometry.MAC)/amb.visc;

%% Identificação do aerofólio e load

if readCm == 1

    if geometry.airfoil == 1
           load('airfoildata\Cm0\naca0012.mat');
           data = naca0012;
    end
    if geometry.airfoil == 2
           load('airfoildata\Cm0\s9026.mat');
           data = s9026;
    end
    if geometry.airfoil == 3
           load('airfoildata\Cm0\e662.mat');
           data = e662;
    end
    if geometry.airfoil == 4
           load('airfoildata\Cm0\e403.mat');
           data = e403;
    end
    if geometry.airfoil == 5
           load('airfoildata\Cm0\e583.mat');
           data = e583;
    end
    if geometry.airfoil == 6
           load('airfoildata\Cm0\e603.mat');
           data = e603;
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
           load('airfoildata\Cm0\fx61163.mat');
           data = fx61163;
    end
    if geometry.airfoil == 8
           load('airfoildata\Cm0\fxs02196.mat');
           data = fxs02196;
    end
%     if geometry.airfoil == 13
%            load('airfoildata\Cm0\hq359.mat');
%            data = hq359;
%     end
    if geometry.airfoil == 9
           load('airfoildata\Cm0\naca23012.mat');
           data = naca23012;
    end
    if geometry.airfoil == 10
           load('airfoildata\Cm0\naca633618.mat');
           data = naca633618;
    end
    if geometry.airfoil == 11
           load('airfoildata\Cm0\sm701.mat');
           data = sm701;
    end

end    
    
readCm = 0;    
    
%% Leitura


% 0.52 s / deg
Re = 500000; 
for i=1:1:10
   airfoil_Re(i)=Re;
   Re=Re+1000000;
end    

for i = 1:1:length(airfoil_Re);
  erro(i) = abs(Re_MAC-airfoil_Re(i))/Re_MAC;
end

% Localizar os Re mais próximos do BD
[erro,pos] = min(erro);


if pos == 1
   alpha =  data(:,1);
   Cm = data(:,2);
end    
if pos == 2
   alpha =  data(:,4);
   Cm = data(:,5);
end   
if pos == 3
   alpha =  data(:,7);
   Cm = data(:,8);
end   
if pos == 4
   alpha =  data(:,10);
   Cm = data(:,11);
end   
if pos == 5
   alpha =  data(:,13);
   Cm = data(:,14);
end   
if pos == 6
   alpha =  data(:,16);
   Cm = data(:,17);
end   
if pos == 7
   alpha =  data(:,19);
   Cm = data(:,20);
end   
if pos == 8
   alpha =  data(:,22);
   Cm = data(:,23);
end   
if pos == 9
   alpha =  data(:,25);
   Cm = data(:,26);
end   
if pos == 10
   alpha =  data(:,28);
   Cm = data(:,29);
end   

% Encontra posições de 'NaN' nos vetores
i= 1;
flag =0;
while flag == 0 &&  i < length(alpha)
    if  isnan(alpha(i)) == 1
        flag = 1;
    end
    i=i+1;
end

alpha = alpha(1:i-2,1);
Cm = Cm(1:i-2,1);

% Interpolação
Cm0 =  interp1(alpha,Cm,alpha_w,'PCHIP','extrap');


end

