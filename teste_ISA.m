% teste ISA

%Veredito: Diferença pequena na velocidade do som afima de  5 km.


clear all
close all
clc



i=1
for H=0:100:15000
    [T2(i), a2(i), P2(i), rho2(i)] = atmosisa(H);
    C1= 1.458*10^(-6); %[kg/msK^0.5]
    S= 110.4;   % [K]
    visc2(i)=C1*(T2(i)^1.5)/(T2(i)+S);
    
    
    [P(i),T(i),a(i),rho(i),visc(i)] = ISA( H, 0);
    i=i+1;
end

H=[0:100:15000];

plot(H,T)
hold on
plot(H,T2)

figure
plot(H,a)
hold on
plot(H,a2)

figure
plot(H,P)
hold on
plot(H,P2)

figure
plot(H,rho)
hold on
plot(H,rho2)

figure
plot(H,visc)
hold on
plot(H,visc2)