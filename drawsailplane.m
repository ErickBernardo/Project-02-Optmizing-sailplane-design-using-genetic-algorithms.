function [] = drawsailplane(aircraft)
% Status: Programado [] Verificado [] Validado []
% Objetivo: Desenhar o planador


%teste

% aircraft.wing.sweepLE=5;
% aircraft.wing.span=22;
% aircraft.wing.cr = 1;

%% VISTA SUPERIOR

figure

Rfus = aircraft.fuselage.radius;
Lf= aircraft.fuselage.Lf;
Xw = aircraft.wing.positionx;
ri=0.10*Rfus;
rf=0.05*Rfus;


%% Fuselagem

xa=linspace(0,Xw,10);
xd=linspace(Xw,Lf,10);

ffusa = @(x) ((Rfus-ri)/Xw)*x+ri;
ffusd = @(x) ((Rfus-rf)/(Xw-Lf))*x+Rfus-((Rfus-rf)*Xw)/(Xw-Lf);


plot(xa,ffusa(xa),'b')
hold on
plot(xa,-ffusa(xa),'b')
plot(xd,ffusd(xd),'b')
plot(xd,-ffusd(xd),'b')
grid on

% fechando frente
plot([0 0],[-ri ri])
% fechando atrás
plot([aircraft.fuselage.Lf aircraft.fuselage.Lf],[-rf rf])

%xlim([-0.5*Lf 1.5*Lf])
% xlim([-0.1*aircraft.wing.span 1.5*aircraft.fuselage.Lf])
% ylim([-0.75*aircraft.wing.span 0.75*aircraft.wing.span])
% xlim([-2*Lf 2*Lf])
axis('equal','xy');
xlabel('[m]')
ylabel('[m]')

%% Wing

%Cr
plot([Xw,Xw+aircraft.wing.cr],[0 0],'r');
% Ac
%plot(aircraft.wing.Xac,0.25*aircraft.wing.cr*tan(aircraft.wing.i*(pi/180)),'+')

plot([Xw,Xw+0.5*aircraft.wing.span*tan(aircraft.wing.sweepLE*(pi/180))],[0, 0.5*aircraft.wing.span],'r')
plot([Xw,Xw+0.5*aircraft.wing.span*tan(aircraft.wing.sweepLE*(pi/180))],[0, -0.5*aircraft.wing.span],'r')

plot([Xw+0.5*aircraft.wing.span*tan(aircraft.wing.sweepLE*(pi/180)), Xw+0.5*aircraft.wing.span*tan(aircraft.wing.sweepLE*(pi/180))+aircraft.wing.ct],[0.5*aircraft.wing.span,0.5*aircraft.wing.span],'r')
plot([Xw+0.5*aircraft.wing.span*tan(aircraft.wing.sweepLE*(pi/180)), Xw+0.5*aircraft.wing.span*tan(aircraft.wing.sweepLE*(pi/180))+aircraft.wing.ct],[-0.5*aircraft.wing.span,-0.5*aircraft.wing.span],'r')

plot([Xw+0.5*aircraft.wing.span*tan(aircraft.wing.sweepLE*(pi/180))+aircraft.wing.ct, Xw+aircraft.wing.cr],[0.5*aircraft.wing.span, 0],'r')
plot([Xw+0.5*aircraft.wing.span*tan(aircraft.wing.sweepLE*(pi/180))+aircraft.wing.ct, Xw+aircraft.wing.cr],[-0.5*aircraft.wing.span, 0],'r')




%% HT

Xht=aircraft.ht.Xht;

plot([Xht,Xht+0.5*aircraft.ht.span*tan(aircraft.ht.sweepLE*(pi/180))],[0, 0.5*aircraft.ht.span],'r')
plot([Xht,Xht+0.5*aircraft.ht.span*tan(aircraft.ht.sweepLE*(pi/180))],[0, -0.5*aircraft.ht.span],'r')


plot([Xht+0.5*aircraft.ht.span*tan(aircraft.ht.sweepLE*(pi/180)),Xht+0.5*aircraft.ht.span*tan(aircraft.ht.sweepLE*(pi/180))+aircraft.ht.ct],[0.5*aircraft.ht.span,0.5*aircraft.ht.span],'r')
plot([Xht+0.5*aircraft.ht.span*tan(aircraft.ht.sweepLE*(pi/180)),Xht+0.5*aircraft.ht.span*tan(aircraft.ht.sweepLE*(pi/180))+aircraft.ht.ct],[-0.5*aircraft.ht.span,-0.5*aircraft.ht.span],'r')


plot([Xht+0.5*aircraft.ht.span*tan(aircraft.ht.sweepLE*(pi/180))+aircraft.ht.ct, aircraft.ht.Xht+aircraft.ht.cr],[0.5*aircraft.ht.span, 0],'r')
plot([Xht+0.5*aircraft.ht.span*tan(aircraft.ht.sweepLE*(pi/180))+aircraft.ht.ct, aircraft.ht.Xht+aircraft.ht.cr],[-0.5*aircraft.ht.span, 0],'r')


%Ac
%plot(aircraft.ht.Xac,aircraft.ht.Zac,'+')

%% VT


title('Vista Superior')

set(gca,'Fontsize',15)



% VISTA LATERAL
%% Inputs geometria

figure

Rfus = aircraft.fuselage.radius;
Lf= aircraft.fuselage.Lf;
Xw = aircraft.wing.positionx;
ri=0.10*Rfus;
rf=0.05*Rfus;


%% Fuselagem

xa=linspace(0,Xw,10);
xd=linspace(Xw,Lf,10);

ffusa = @(x) ((Rfus-ri)/Xw)*x+ri;
ffusd = @(x) ((Rfus-rf)/(Xw-Lf))*x+Rfus-((Rfus-rf)*Xw)/(Xw-Lf);


plot(xa,ffusa(xa),'b')
hold on
plot(xa,-ffusa(xa),'b')
plot(xd,ffusd(xd),'b')
plot(xd,-ffusd(xd),'b')
grid on

% fechando frente
plot([0 0],[-ri ri])
% fechando atrás
plot([aircraft.fuselage.Lf aircraft.fuselage.Lf],[-rf rf])

xlim([-0.5*Lf 1.25*Lf])
% ylim([-Lf Lf])
axis('equal','xy');


%% Wing

%Cr
plot([Xw,Xw+aircraft.wing.cr],[0.5*aircraft.wing.cr*tan(aircraft.wing.i*(pi/180)),-0.5*aircraft.wing.cr*tan(aircraft.wing.i*(pi/180))],'r');
% Ac
%plot(aircraft.wing.Xac,0.25*aircraft.wing.cr*tan(aircraft.wing.i*(pi/180)),'+')


%% HT

%Cr
plot([aircraft.ht.Xht,aircraft.ht.Xht+aircraft.ht.cr],[aircraft.ht.Zac,aircraft.ht.Zac],'r')
%Ac
%plot(aircraft.ht.Xac,aircraft.ht.Zac,'+')

%% VT
plot([aircraft.vt.Xvt,aircraft.vt.Xvt+aircraft.vt.span*tan(aircraft.vt.sweepLE*(pi/180))],[0, aircraft.vt.span],'r')
plot([aircraft.vt.Xvt+aircraft.vt.span*tan(aircraft.vt.sweepLE*(pi/180)), aircraft.vt.Xvt+aircraft.vt.span*tan(aircraft.vt.sweepLE*(pi/180))+aircraft.vt.ct],[aircraft.vt.span,aircraft.vt.span],'r')
plot([aircraft.vt.Xvt+aircraft.vt.span*tan(aircraft.vt.sweepLE*(pi/180))+aircraft.vt.ct,aircraft.fuselage.Lf],[aircraft.vt.span, 0],'r')

title('Vista Lateral')
xlabel('[m]')
ylabel('[m]')

set(gca,'Fontsize',15)


end