function aircraft = read_from_parameters(p)
% Status: Programado [x] Verificado [x] Validado [x]
% Objetivo: Definir todos as variáveis, valores fixos e de operação na
% estrutura aircraft

global H readCm read_airfoil;
global ngeom  pgeom;

% Contar número de geometrias analisadas
ngeom=ngeom+1;
readCm = 1;  % controla leitura do BD
read_airfoil = 1;

pgeom = p; % para investigar erros

%% Weight parameter
%variable
aircraft.general.W = p(11); %weigth
aircraft.general.SM = p(12); %static margin


%% Fuselage
%fixed
aircraft.fuselage.radius=0.5334; % [m] > 42 pol ver padrão sentado
%calculated
aircraft.fuselage.Lf=(5*10^(-6))*(aircraft.general.W^2)-0.0004*aircraft.general.W+6.1417; % Lf em [m] e W em [Kg] -fit do BD

%% wing parameters
%variable
aircraft.wing.AR = p(1);
aircraft.wing.span_Lf = p(2);                  
aircraft.wing.span = aircraft.wing.span_Lf*aircraft.fuselage.Lf;
aircraft.wing.lambda = p(3);
aircraft.wing.airfoil = p(4);
aircraft.wing.twist = p(5); %[deg - neg washout]
aircraft.wing.positionx = p(6); % posição em [m] do início da asa
%fixed
aircraft.wing.sweepLE = 1; %[deg]
aircraft.wing.i= 2; %[deg]
aircraft.wing.dihedral = 2; %[deg] não influencia nas contas realizadas
aircraft.wing.arrangement = 'mid';  %low, mid, high
%calculated
aircraft.wing.S = aircraft.wing.span^2/aircraft.wing.AR;
aircraft.wing.cr =  (2*aircraft.wing.S)/(aircraft.wing.span*(1+aircraft.wing.lambda));
aircraft.wing.ct = aircraft.wing.lambda*aircraft.wing.cr;
aircraft.wing.sweep14 = (180/pi)*atan(tan(aircraft.wing.sweepLE*(pi/180))-(1-aircraft.wing.lambda)/(aircraft.wing.AR*(1+aircraft.wing.lambda))); 
aircraft.wing.MAC = (2/3)*aircraft.wing.cr*((1+aircraft.wing.lambda+aircraft.wing.lambda^2)/(1+aircraft.wing.lambda));
aircraft.wing.YMAC = (aircraft.wing.span/6)*((1+2*aircraft.wing.lambda)/(1+aircraft.wing.lambda));
aircraft.wing.Xac = aircraft.wing.positionx+aircraft.wing.YMAC*tan(aircraft.wing.sweepLE*(pi/180))+0.25*aircraft.wing.MAC;

%% ht parameters

%variable
aircraft.ht.arrangement = p(7); % tail arrangement
aircraft.ht.airfoil = p(8);
aircraft.ht.AR = p(9);
aircraft.ht.lambda = p(10);
aircraft.ht.cf_c = p(13);
%fixed
aircraft.ht.twist = 0;
aircraft.ht.sweepLE = aircraft.wing.sweepLE+5; %[deg] Ref Raymer
aircraft.ht.eta = 0.9; % eta = qht/q  
aircraft.ht.i= 0;
if aircraft.ht.arrangement == 3
    aircraft.ht.cht = 0.95*0.5;  
else
   aircraft.ht.cht = 0.5;     
end
%calculated
aircraft.ht.Lht = 0.65*aircraft.fuselage.Lf;
aircraft.ht.S = (aircraft.ht.cht*aircraft.wing.MAC*aircraft.wing.S)/aircraft.ht.Lht;
aircraft.ht.span = sqrt(aircraft.ht.AR*aircraft.ht.S);
aircraft.ht.cr = (2*aircraft.ht.S)/(aircraft.ht.span*(1+aircraft.ht.lambda));
aircraft.ht.ct = aircraft.ht.lambda*aircraft.ht.cr;
aircraft.ht.sweep14 = (180/pi)*atan(tan(aircraft.ht.sweepLE*(pi/180))-(1-aircraft.ht.lambda)/(aircraft.ht.AR*(1+aircraft.ht.lambda))); 
aircraft.ht.MAC = (2/3)*aircraft.ht.cr*((1+aircraft.ht.lambda+aircraft.ht.lambda^2)/(1+aircraft.ht.lambda));
aircraft.ht.YMAC = (aircraft.ht.span/6)*((1+2*aircraft.ht.lambda)/(1+aircraft.ht.lambda));
%aircraft.ht.Xac = aircraft.wing.Xac+aircraft.ht.Lht; 
aircraft.ht.Xht=aircraft.fuselage.Lf-aircraft.ht.cr;
aircraft.ht.Xac = aircraft.ht.Xht+aircraft.ht.YMAC*tan(aircraft.ht.sweepLE*(pi/180))+0.25*aircraft.ht.MAC; 
aircraft.ht.cf=aircraft.ht.MAC*aircraft.ht.cf_c;
aircraft.ht.ctf=aircraft.ht.cf_c*aircraft.ht.ct;
aircraft.ht.crf=aircraft.ht.cf_c*aircraft.ht.cr;
aircraft.ht.spanf=aircraft.ht.span;
aircraft.ht.Sf = 2*(0.5*aircraft.ht.spanf*(aircraft.ht.crf+aircraft.ht.ctf))/2;
aircraft.ht.sweepHL= atan((aircraft.ht.crf-aircraft.ht.ctf)/(0.5*aircraft.ht.spanf))*(180/pi); % [deg]


%% vt parameters
%fixed
aircraft.vt.AR = 1.2;   %Valores de Ref. Raymer  0.7 - 1.2
aircraft.vt.lambda= 0.8 ; % Raymer 0.6 - 1.0
aircraft.vt.airfoil=1; % naca0012
aircraft.vt.sweepLE = 20; %[deg]
aircraft.vt.cvt = 0.02; %VT volume coef.
if aircraft.ht.arrangement == 3
    aircraft.vt.cvt = 0.95*0.02;      
end
%calculated
aircraft.vt.Lvt = 0.60*aircraft.fuselage.Lf;
aircraft.vt.S = (aircraft.vt.cvt*aircraft.wing.span*aircraft.wing.S)/aircraft.vt.Lvt;
aircraft.vt.span = sqrt(aircraft.vt.AR*aircraft.vt.S);
aircraft.vt.cr = (2*aircraft.vt.S)/(aircraft.vt.span*(1+aircraft.vt.lambda));
aircraft.vt.ct = aircraft.vt.lambda*aircraft.vt.cr;
aircraft.vt.sweep14 = (180/pi)*atan(tan(aircraft.vt.sweepLE*(pi/180))-(1-aircraft.vt.lambda)/(aircraft.vt.AR*(1+aircraft.vt.lambda))); 
aircraft.vt.MAC = (2/3)*aircraft.vt.cr*((1+aircraft.vt.lambda+aircraft.vt.lambda^2)/(1+aircraft.vt.lambda));
aircraft.vt.YMAC = 2*(aircraft.vt.span/6)*((1+2*aircraft.vt.lambda)/(1+aircraft.vt.lambda));
% aerofólio fixo - naca0012
aircraft.vt.t_c = 0.12;
aircraft.vt.x_c_max = 0.404; 

aircraft.vt.Xvt=aircraft.fuselage.Lf-aircraft.vt.cr;
aircraft.vt.Xac = aircraft.vt.Xvt+aircraft.vt.YMAC*tan(aircraft.vt.sweepLE*(pi/180))+0.25*aircraft.vt.MAC; 




%posição Zac do HT em relação ao CG (simplificado)  1:convencional - 2: cruz - 3: "T" - varição nº inteiros
if aircraft.ht.arrangement == 1
    aircraft.ht.Zac = 0;
end
if aircraft.ht.arrangement == 2
    aircraft.ht.Zac = 0.5*aircraft.vt.span;
end
if aircraft.ht.arrangement == 3
    aircraft.ht.Zac = aircraft.vt.span;
end




%% Ambiente de operação
%fixed
aircraft.amb.H =H;
%[aircraft.amb.T, aircraft.amb.a, aircraft.amb.P, aircraft.amb.rho] = atmosisa(aircraft.amb.H);
[aircraft.amb.P,aircraft.amb.T,aircraft.amb.a,aircraft.amb.rho,aircraft.amb.visc] = ISA( aircraft.amb.H, 0);

%Viscosidade
%Lei de Sutherland
% verificar valores diferentes de C1=1.51204*10^-6  S=120
% C1= 1.458*10^(-6); %[kg/msK^0.5]
% S= 110.4;   % [K]
% aircraft.amb.visc=C1*(aircraft.amb.T^1.5)/(aircraft.amb.T+S);


end

