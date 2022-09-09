function [P,T,a,dens,visc] = ISA( h, deltaISA)
% calcula a densidade,pressão, temperatura e viscosidade dinâmica na (ISA +- deltaISA) em qualquer altitude 0 < h < 105000 m
% viscosidade válida para intervalo restrito. Valid for temperatures between 0 < T < 555 K with an error due to pressure less than 10% below 3.45 MPa.
% [dens]:kg/m^3
% [p]: Pa
T= tempISA(h);
R=287.053;
g=9.81;

%Viscosidade
%Lei de Sutherland
% verificar valores diferentes de C1=1.51204*10^-6  S=120
C1= 1.458*10^(-6); %[kg/msK^0.5]
S= 110.4;   % [K]
visc=C1*(T^1.5)/(T+S);

% Velocidade do som
a= 331.5+0.6*(T-273.15);
%a2=331.45*sqrt(T/273.15)

lamb1=-6.5*10^(-3);  % grad 1
T01=288.15;
dens01=1.225; 
P01=1.01325*10^5;

T02=216.66;    % iso 2
h02=11000;
dens02=dens01*[((T02-deltaISA)/(T01-deltaISA))^(-g/(lamb1*R)-1)];
P02=P01*[((T02-deltaISA)/(T01-deltaISA))^(-g/(lamb1*R))];

lamb3=3*10^(-3);    %grad 3
T03=216.66;
h03=25000;
dens03=dens02*[exp(-g*(h03-h02)/(T02*R))];
P03= P02*[exp(-g*(h03-h02)/(T02*R))];

T04=282.66;    %iso 4
h04=47000;
dens04=dens03*[((T04-deltaISA)/(T03-deltaISA))^(-g/(lamb3*R)-1)]; ;
P04=P03*[((T04-deltaISA)/(T03-deltaISA))^(-g/(lamb3*R))];

lamb5=-4.5*10^(-3);   %grad 5
T05=282.66;
h05=53000;
dens05=dens04*[exp(-g*(h05-h04)/(T04*R))];
P05= P04*[exp(-g*(h05-h04)/(T04*R))];

T06=165.66;   %iso  6
h06=79000;
dens06=dens05*[((T06-deltaISA)/(T05-deltaISA))^(-g/(lamb5*R)-1)];
P06=P05*[((T06-deltaISA)/(T05-deltaISA))^(-g/(lamb5*R))];

lamb7=4*10^(-3);  %grad 7
T07=165.66;
h07=90000;
dens07= dens06*[exp(-g*(h07-h06)/(T06*R))];
P07= P06*[exp(-g*(h07-h06)/(T06*R))];

if h<= 11000 % com gradiente de T
   dens=dens01*[((T-deltaISA)/(T01-deltaISA))^(-g/(lamb1*R)-1)];
   P=P01*[((T-deltaISA)/(T01-deltaISA))^(-g/(lamb1*R))];
end
if  11000 < h && h < 25000 %camada isotérmica
   dens=dens02*[exp(-g*(h-h02)/(T02*R))];
   P=P02*[exp(-g*(h-h02)/(T02*R))];   
end      
if  25000 <= h && h <= 47000 % com gradiente de T
    dens=dens03*[((T-deltaISA)/(T03-deltaISA))^(-g/(lamb3*R)-1)];
    P=P03*[((T-deltaISA)/(T03-deltaISA))^(-g/(lamb3*R))];
end     
if   47000 < h && h <= 53000 %camada isotérmica
    dens=dens04*[exp(-g*(h-h04)/(T04*R))];
    P=P04*[exp(-g*(h-h04)/(T04*R))];   

end    
if   53000 < h && h <= 79000 % com gradiente de T
    dens=dens05*[((T-deltaISA)/(T05-deltaISA))^(-g/(lamb5*R)-1)];
    P=P05*[((T-deltaISA)/(T05-deltaISA))^(-g/(lamb5*R))];

end       
if  79000 < h && h <= 90000 %camada isotérmica
   dens=dens06*[exp(-g*(h-h06)/(T06*R))];
   P=P06*[exp(-g*(h-h06)/(T06*R))];   

end    
if  90000 < h && h <= 105000  % com gradiente de T   
   dens=dens07*[((T-deltaISA)/(T0-deltaISA))^(-g/(lamb7*R)-1)];
   P=P07*[((T-deltaISA)/(T07-deltaISA))^(-g/(lamb7*R))];

end    
    
end