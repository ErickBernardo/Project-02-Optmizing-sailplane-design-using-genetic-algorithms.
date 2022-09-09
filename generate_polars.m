function [ polars ] = generate_polars( geometry, amb , Vinf , alphaMAC,flag)
% Status: Programado [x] Verificado [x] Validado [x]
% Objetivo: Lifting line code / retorna CL CDi e variáveis na estrutura polars

global Clalpha_inf_w CLalpha_w alpha0_w t_c_w x_c_max_w;
global Clalpha_inf_ht CLalpha_ht alpha0_ht t_c_ht x_c_max_ht;


%% Inputs geometry
n=50;
theta= linspace(0,pi,n); %[rad]
y = -(geometry.span/2)*cos(theta);
c = interp1([-geometry.span/2,0,geometry.span/2],[geometry.ct,geometry.cr,geometry.ct],y);  
c=c';


%% Inputs airfoil

if flag == 1   
     Clalpha_inf = Clalpha_inf_w ;  % ASA 
     alpha0 = alpha0_w ;
else
     Clalpha_inf = Clalpha_inf_ht; % HT
     alpha0 = alpha0_ht;
end    


%[Clalpha_inf,~, alpha0, ~, ~] = airfoil_properties(geometry,amb,Vinf,flag);
% Atenção alpha0 > valores negativos > (passar para coluna)

Clalpha_inf=Clalpha_inf*ones(n,1); % Mantendo o Clalpha_inf da MAC cte em y 
alpha0=(pi/180)*alpha0*ones(n,1); %[rad]

twist = interp1([-geometry.span/2,0,geometry.span/2],[geometry.twist,0,geometry.twist],y); %[deg]
twist=twist'; %[deg]

% avaliar a torção no Y da MAC
if geometry.twist ~= 0
   %p=polyfit(y,twist,4);  
   %twist_MAC=polyval(p,geometry.YMAC);
   twist_MAC=interp1(y,twist,geometry.YMAC,'PCHIP','extrap');
else
   twist_MAC =0;
end

alpharoot=alphaMAC + twist_MAC;  %[deg]
alphar=alpharoot*ones(n,1); % [deg]

alpha = (alphar-twist)*(pi/180); %[rad]  


%% Lifting line
% Sistema CA=B        A = [A1 A2 ... An-2]'

theta=theta(2:n-1); % elimino 0 = 0  >  pos 1 e n

mu = (c.*Clalpha_inf)/(4*geometry.span);
B = mu(2:n-1,1).*(alpha(2:n-1,1)-alpha0(2:n-1,1)).*(sin(theta))';

for i=1:1:n-2
    for j=1:1:n-2
        C(i,j)= sin(j*theta(i))*(sin(theta(i))+j*mu(i));     
    end
end

A = C\B;

% Lift
polars.CL = pi*geometry.AR*A(1);


% Drag

delta = 0;
for j=3:2:n-2
    delta=delta+(j*(A(j)/A(1))^2);
end
   
polars.K =(1+delta)/(pi*geometry.AR);
polars.CDi = ((polars.CL^2)/(pi*geometry.AR))*(1+delta);

% polars.L=polars.CL*(0.5)*amb.rho*(Vinf^2)*geometry.S;
% polars.Di = polars.CDi*(0.5)*amb.rho*(Vinf^2)*geometry.S;
% polars.A=A;
% polars.B=B;
% polars.C=C;
% polars.mu = mu;
% polars.twist=twist;
% polars.c=c;
% polars.y=y;
% polars.alpha = alpha;
% polars.alpha0 = alpha0;
% polars.Clalpha_inf = Clalpha_inf;
% polars.theta=theta;



end

