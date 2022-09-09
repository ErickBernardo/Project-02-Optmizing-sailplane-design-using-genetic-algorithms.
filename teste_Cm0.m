% Teste função airfoil_Cm0

close all
clear all
clc


global readCm data

readCm = 1;

aircraft.wing.MAC = 1.69;
aircraft.amb.rho = 1.225;
aircraft.amb.visc =1.79*10^(-5);
aircraft.wing.airfoil = 3;


Vinf=20;

% for airfoil=3:1:6
%     aircraft.wing.airfoil=airfoil;
%     airfoil
%     i=1;
%     for alpharoot = -20: 10 : 30 
%            Cm0(i) = airfoil_Cm0(aircraft.wing,aircraft.amb,Vinf,alpharoot);
%            alpha(i)=alpharoot;
%            i=i+1;
%     end    
% 
% end


alpharoot = [-5:0.5:15];
Cm0 = airfoil_Cm0(aircraft.wing,aircraft.amb,Vinf,alpharoot)
    

plot(alpharoot,Cm0,'+')
hold on

xlabel('alpha')
ylabel('Cm0')
grid on



Re_MAC= (aircraft.amb.rho*Vinf*aircraft.wing.MAC)/aircraft.amb.visc;

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


plot(alpha,Cm,'s')
