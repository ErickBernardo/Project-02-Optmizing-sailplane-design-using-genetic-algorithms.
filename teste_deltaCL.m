% Teste deltaCL

close all
clear all
clc

%% Teste fit do gráfico deltaCl_deltae - Status: Validado[x]

% % %x = [0 0.5] - gráfico 16.6 - Raymer    >> remover ptos de novo
% % f015 = @(x) -306.19784*x.^4 + 329.69120*x.^3 - 130.13317*x.^2 + 29.81393*x + 1.32817;
% % f010 = @(x) -411.46152*x.^4 + 416.50507*x.^3 - 149.46238*x.^2 + 30.09765*x + 1.33264;
% % f006 = @(x) -271.52207*x.^4 + 306.96907*x.^3 - 124.34825*x.^2 + 27.57730*x + 1.32596;
% % f002 = @(x) -299.05637*x.^4 + 323.82343*x.^3 - 126.05523*x.^2 + 26.98442*x + 1.33176;
% % 
% % 
% % geometry.cf_c = 0.3;
% % t_c = 0.06;
% % 
% % y = [f002(geometry.cf_c-0.05), f006(geometry.cf_c-0.05), f010(geometry.cf_c-0.05), f015(geometry.cf_c-0.05)]
% % z = [0.02, 0.06, 0.10, 0.15]
% % dCl_ddelta = interp1(z,y,t_c) % interpolação no t/c desejado
% % 
% % 
% % x=[0.05:0.01:0.5];
% % xaux = x - 0.05*ones(1,length(x));
% % 
% % plot(x, f015(xaux))
% % hold on
% % plot(x, f010(xaux))
% % plot(x, f006(xaux))
% % plot(x, f002(xaux))
% % grid on
% % 
% % xlabel('cf/c')
% % ylabel('deltaCl/deltae')
% % legend('0.15','0.10','0.06','0.02')



%% Teste fit do gráficos Kf - Status: Validado[x]

% %%x = [0 80] - gráfico 16.7 - Raymer
% 
% f010 = @(x) 0.0000000285*x.^5 - 0.0000039419*x.^4 + 0.0001951911*x.^3 - 0.0038817430*x.^2 + 0.0127005236*x + 0.9962081303;
% f030 = @(x) -0.000000002537765004968760000000*x.^6 + 0.000000429717991940783000000000*x.^5 - 0.000028058441605471900000000000*x.^4 + 0.000870528891510958000000000000*x.^3 - 0.012282648493993500000000000000*x.^2 + 0.042061684436362200000000000000*x + 0.981886056558267000000000000000;
% f040 = @(x)-0.000000002283781724371030000000*x.^6 + 0.000000403918057129398000000000*x.^5 - 0.000027014881838372000000000000*x.^4 + 0.000837255908470169000000000000*x.^3 - 0.011346132857369200000000000000*x.^2 + 0.029753953625942100000000000000*x + 0.988255123575527000000000000000;
% f050 = @(x) -0.00000000314300119936*x.^6 + 0.00000050138567891326*x.^5 - 0.00003038012866918290*x.^4 + 0.00085285799086065600*x.^3 - 0.01022690299819830000*x.^2 + 0.01361910412441600000*x + 0.99641237824653200000;
% 
% geometry.cf_c=0.15;
% deltae=60;
% 
% y = [f010(deltae-10), f030(deltae-10), f040(deltae-10), f050(deltae-10)]
% z = [0.10 , 0.30 , 0.40 , 0.50]
% 
% Kf = interp1(z,y,geometry.cf_c)
% 
% deltae = [10:1:60]; %[deg]
% xaux = deltae-10*ones(1,length(deltae));
% 
% plot(deltae, f050(xaux))
% hold on
% plot(deltae, f040(xaux))
% plot(deltae, f030(xaux))
% plot(deltae, f010(xaux))
% grid on
% 
% 
% xlabel('deltae [deg]')
% ylabel('Kf')
% legend('0.50','0.40','0.30','0.10')


%% Teste da função deltaCL - Status: Validado[x]

% geometria
ARw = 7.9;
bw=10;
lambdaw = 0.27;
airfoil_w = 14;
twist=0;
xw=0.1;
tail_arrang=3;
airfoil_ht=1;
AR_ht = 6;
b_ht=1.05;
lambda_ht=0.3;
W = 204;
SM = 0.05;
cf_c_ht=0.1;

global H ngeom
H = 0;
ngeom =0;

global Clalpha_inf_ht CLalpha_ht alpha0_ht t_c_ht x_c_max_ht;

p = [ARw, bw, lambdaw, airfoil_w, twist, xw, tail_arrang, airfoil_ht, AR_ht, b_ht, lambda_ht, W, SM, cf_c_ht];
aircraft = read_from_parameters(p);

% t/c
Vinf = 20;
[Clalpha_inf,CLalpha, alpha0, t_c, x_c_max] = airfoil_properties(aircraft.ht,aircraft.amb,Vinf);

Clalpha_inf_ht = Clalpha_inf ;
alpha0_ht = alpha0;


% deltaCL
i=1;
for deltae=0:20:60
     dCL(i) = deltaCL(deltae, aircraft.ht, t_c);
     i=i+1;
end

% Curva CL x alphaw

i=1;
for alpharoot = -8: 1 : 24 
       polars = generate_polars(aircraft.ht, aircraft.amb, Vinf, alpharoot,2);
       CL(i) = polars.CL;
       alpha(i)=alpharoot;
       i=i+1;
end       
       
plot(alpha,CL,'*')
hold on

for j=1:1:length(dCL)
    delta=dCL(j)*ones(1,length(CL)); 
    plot(alpha,CL+delta);
end

legend('CL','delta=0','delta=20º','delta=40º','delta=60º')
xlabel('alpha')
ylabel('CL')
grid on



