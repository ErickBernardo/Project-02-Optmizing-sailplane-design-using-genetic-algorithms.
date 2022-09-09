% Plot de genes por altitude

close all

Hi=0;
Hf=3000;
dH =500;

i=1;
for H = Hi:dH:Hf

   h = num2str(H);
   filename = strcat('1H', h);
   load(filename)
   aircraft=read_from_parameters(res);
   
   %drawsailplane(aircraft)
   
   rho(i) = aircraft.amb.rho;
   
   ARw(i)=aircraft.wing.AR;
   span_Lf(i) = aircraft.wing.span_Lf;
   lambdaw(i) = aircraft.wing.lambda;
   airfoilw(i) = aircraft.wing.airfoil;
   twistw(i) = aircraft.wing.twist;
   Sw(i) = aircraft.wing.S;
   spanw(i) = aircraft.wing.span;
   
   ARht(i)=aircraft.ht.AR;
   arrangement(i) = aircraft.ht.arrangement;
   lambdaht(i) = aircraft.ht.lambda;
   Sht(i) = aircraft.ht.S;
   spanht(i) = aircraft.ht.span;
   airfoilht(i) = aircraft.ht.airfoil;


   W(i)=aircraft.general.W;
   SM(i) = aircraft.general.SM;
   Lf(i) = aircraft.fuselage.Lf;
   
   Vavgmax(i) = -fval;
   
   
   i = i+1; 
end    

H = [Hi:dH:Hf];
H=H./1000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ASA / HT

plot(H,ARw,'--o')
hold on
plot(H,ARht,'--o')
xlabel('Altitude [km]')
ylabel('AR')
title('Alongamento')
legend('ASA','Estabilizador Horizontal')
grid on
set(gca,'Fontsize',15)

figure
plot(H,span_Lf,'--o')
xlabel('Altitude [km]')
ylabel('b/L_{f}')
title(' b/L_{f}')
grid on
set(gca,'Fontsize',15)

figure
plot(H,spanw,'--o')
hold on
plot(H,spanht,'--o')
xlabel('Altitude [km]')
ylabel('b [m]')
legend('ASA','Estabilizador Horizontal')
title('Envergadura')
grid on
set(gca,'Fontsize',15)

figure
plot(H,lambdaw,'--o')
hold on
plot(H,lambdaht,'--o')
xlabel('Altitude [km]')
ylabel('Afilamento')
title(' Afilamento')
legend('ASA','Estabilizador Horizontal')
grid on
set(gca,'Fontsize',15)

figure
plot(H,twistw,'--o')
xlabel('Altitude [km]')
ylabel('Torção [º]')
title(' Torção - Asa')
grid on
set(gca,'Fontsize',15)

figure
plot(H,Sw,'--o')
hold on
plot(H,Sht,'--o')
xlabel('Altitude [km]')
ylabel('S [m^2]')
title('Área')
legend('ASA','Estabilizador Horizontal')
grid on
set(gca,'Fontsize',15)



%% geral


figure
plot(H,Vavgmax,'--o')
xlabel('Altitude [km]')
ylabel('Vcc max [m/s]')
title(' Velocidade de cross-country')
grid on
set(gca,'Fontsize',15)


figure
plot(H,Lf,'--o')
xlabel('Altitude [km]')
ylabel('Lf [m]')
title(' Comprimento da fuselagem')
grid on
set(gca,'Fontsize',15)

figure
plot(H,W,'--o')
xlabel('Altitude [km]')
ylabel('MTOW [kg]')
title(' MTOW')
grid on
set(gca,'Fontsize',15)


figure 
plot(H,airfoilw,'--o')
hold on
plot(H,airfoilht,'--o')
legend('ASA','Estabilizador Horizontal')
xlabel('Altitude [km]')
ylabel('Aerofólio')
title('Aerofólio')
grid on
set(gca,'Fontsize',15)


% figure
% 
% a1 = plot(H,ARw,'--ob')
% hold on
% ax1 = gca;
% xlabel('Altitude [km]')
% ylabel('AR - ASA')
% 
% 
% set(gca,'Fontsize',15)
% 
% ax2 = axes('YAxisLocation','right',...
%     'Color','none');
% %b1 = plot(H,ARht,'--or')
% b1 = line(H,ARht,'Parent',ax2,'Color','r', 'LineStyle','--')
% ylabel('AR - HT')
% grid on
% 
% %legend('Location','northeastoutside')
% legend([a1 b1],{'ASA','Estabilizador Horizontal'})
% title('Alongamento')
% 
% set(gca,'Fontsize',15)

