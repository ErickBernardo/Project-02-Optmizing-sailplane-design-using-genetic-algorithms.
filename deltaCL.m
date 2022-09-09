function deltaCL = deltaCL(deltae, geometry, t_c)
% Status: Programado [x] Verificado [x] Validado [x]
% Objetivo: Retornar o acréscimo de sustentação devido a deflexão deltae na
% superfície de controle  - (profundor ou airelon)
% Ref: Raymer

%% dCl_ddelta

% y = dCl_ddelta
% z = t/c
% x = cf/c

%x = [0 0.5] - gráfico 16.6 - Raymer    >> remover ptos de novo
f015 = @(x) -306.19784*x.^4 + 329.69120*x.^3 - 130.13317*x.^2 + 29.81393*x + 1.32817;
f010 = @(x) -411.46152*x.^4 + 416.50507*x.^3 - 149.46238*x.^2 + 30.09765*x + 1.33264;
f006 = @(x) -271.52207*x.^4 + 306.96907*x.^3 - 124.34825*x.^2 + 27.57730*x + 1.32596;
f002 = @(x) -299.05637*x.^4 + 323.82343*x.^3 - 126.05523*x.^2 + 26.98442*x + 1.33176;

y = [f002(geometry.cf_c-0.05), f006(geometry.cf_c-0.05), f010(geometry.cf_c-0.05), f015(geometry.cf_c-0.05)]; % deslocado o eixo x p/ melhor fit das curvas
z = [0.02, 0.06, 0.10, 0.15];
dCl_ddelta = interp1(z,y,t_c,'linear','extrap'); % interpolação no t/c desejado

%% Kf

% y = Kf
% z = cf/c
% x = deltae [deg]

deltae_orig = deltae;
deltae=abs(deltae);

if deltae > 10
    %x = [0 80] - gráfico 16.7 - Raymer
    f010 = @(x) 0.0000000285*x.^5 - 0.0000039419*x.^4 + 0.0001951911*x.^3 - 0.0038817430*x.^2 + 0.0127005236*x + 0.9962081303;
    f030 = @(x) -0.000000002537765004968760000000*x.^6 + 0.000000429717991940783000000000*x.^5 - 0.000028058441605471900000000000*x.^4 + 0.000870528891510958000000000000*x.^3 - 0.012282648493993500000000000000*x.^2 + 0.042061684436362200000000000000*x + 0.981886056558267000000000000000;
    f040 = @(x)-0.000000002283781724371030000000*x.^6 + 0.000000403918057129398000000000*x.^5 - 0.000027014881838372000000000000*x.^4 + 0.000837255908470169000000000000*x.^3 - 0.011346132857369200000000000000*x.^2 + 0.029753953625942100000000000000*x + 0.988255123575527000000000000000;
    f050 = @(x) -0.00000000314300119936*x.^6 + 0.00000050138567891326*x.^5 - 0.00003038012866918290*x.^4 + 0.00085285799086065600*x.^3 - 0.01022690299819830000*x.^2 + 0.01361910412441600000*x + 0.99641237824653200000;

    y = [f010(deltae-10), f030(deltae-10), f040(deltae-10), f050(deltae-10)];
    z = [0.10 , 0.30 , 0.40 , 0.50];

    Kf = interp1(z,y,geometry.cf_c,'linear','extrap'); % interpolação no cf/c desejado
else
    Kf = 1;
end


%% deltaCL
deltaCL =  0.9*Kf*(dCl_ddelta)*(geometry.Sf/geometry.S)*cos(geometry.sweepHL*(pi/180))*(deltae_orig*(pi/180));


end

