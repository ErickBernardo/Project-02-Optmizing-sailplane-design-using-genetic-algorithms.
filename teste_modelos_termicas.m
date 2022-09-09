% Teste modelos de térmicas

close all
clear all

ReqA1 = 0:0.1:131;
Req=0:0.1:150;


VTA1 = fmodelA1(ReqA1);
VTA2 = fmodelA2(Req);
VTB1 = fmodelB1(Req);
VTB2 = fmodelB2(Req);


plot(ReqA1,VTA1,'LineWidth',1')
hold on
plot(Req,VTA2,'LineWidth',1')
plot(Req,VTB1,'LineWidth',1')
plot(Req,VTB2,'LineWidth',1')

legend('A1','A2','B1','B2')

grid on

xlabel('R [m]')
ylabel('Vt [m/s]')
title( 'Modelos de térmicas de Horstmann') 
set(gca,'Fontsize',15)







