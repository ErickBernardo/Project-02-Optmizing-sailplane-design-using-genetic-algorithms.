function [ T ] = tempISA(  h )
% T(h): h escalar
%calcula a temperatura T [K] em qualquer altitude 0 < h < 105000 m da ISA
%camadas com gradiente de T e tropopausas

R=287.053;
g=9.81;

if h < 11000
    lamb=-6.5*10^(-3);
    T=lamb*(h-0)+ 288.15;
end
if  11000 <= h && h <= 25000 
      T=216.66;
end 
      
if  25000 < h && h < 47000 
     lamb=3*10^(-3);
     T=lamb*(h-25000)+ 216.66; 
end     
if   47000 <= h && h <= 53000
      T=282.66; 
end      
if   53000 < h && h < 79000
      T0=282.66;
      lamb=-4.5*10^(-3)
      T=lamb*(h-53000)+T0;
end       
if  79000 <= h && h <= 90000
       T=165.66;
end           
if  90000 < h && h <= 105000    
       T0=165.66;
       h0=90000;
       lamb=4*10^(-3);
       T=lamb*(h-h0)+T0;
end    
 


end

