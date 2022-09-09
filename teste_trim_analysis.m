% Teste f. trim_analysis

close all
clear all
clc

global ngeom 
global H

ngeom = 0;
H = 0;


% Input aircraft   - Modelo SGS 135 (coluna AM - excel)
% ARw = 23.3;
% bw=15;
% lambdaw = 0.4;
% airfoil_w = 3;
% twist=0;
% xw=0.15;
% tail_arrang=3;
% airfoil_ht=1;
% AR_ht = 4.16;
% b_ht=3.5;
% lambda_ht=0.8;
% W = 422;
% SM = 0.10;
% cf_c_ht=0.5;
% 
% p = [ARw, bw, lambdaw, airfoil_w, twist, xw, tail_arrang, airfoil_ht, AR_ht, b_ht, lambda_ht, W, SM, cf_c_ht];
% aircraft = read_from_parameters(p);

load('geometrias\pgeom1.mat')
p = pgeom;
aircraft = read_from_parameters(p);



%CL_trimado = 0.5;

%Vg = 27;



%% Teste da função -  Status: validado[x]

for Vg = 15:10:50
    i=1;
    for CL_trimado = -0.5:0.2:1.5
           aircraft.trim =  trim_analysis(aircraft,CL_trimado,Vg)
    %        deltae_trim(i) = aircraft.trim.ht.deltae_trim;
    %        alpha_wtrim(i) = aircraft.trim.wing.alpha_trim;
    %        alpha_httrim(i) = aircraft.trim.ht.alpha_trim;
           CDi(i) = aircraft.trim.CDi
           i=i+1;
    end
end
CL = [-0.5:0.2:1.5];

plot(CL,deltae_trim)
xlabel('CL')
ylabel('deltae')
grid on

figure
plot(CL,alpha_wtrim)
xlabel('CL')
ylabel('alpha_w')
grid on

figure
plot(CL,alpha_httrim)
xlabel('CL')
ylabel('alpha_ht')
grid on

figure
plot(CL,CDi)
xlabel('CL')
ylabel('CDi')
grid on

%% Teste gráfico v4

% global Clalpha_inf_w CLalpha_w alpha0_w t_c_w x_c_max_w;
% global Clalpha_inf_ht CLalpha_ht alpha0_ht t_c_ht x_c_max_ht;
% 
% 
% %% INPUTS
% 
% % Limites de variação de deflexão de profundor
% deltae_min = -5; %[deg]
% deltae_max = 0; %[deg]   
% % Limites de deflexão de AoA da asa
% alphai_w=-4;
% alphaf_w=10;
% 
% trim.CL_trim = CL_trimado;
% ddeltae = 5;
% dalpha_w = 14;
% 
% [trim.wing.Clalpha_inf,trim.wing.CLalpha, trim.wing.alpha0, trim.wing.t_c, trim.wing.x_c_max] = airfoil_properties(aircraft.wing,aircraft.amb,Vg);  
% [trim.ht.Clalpha_inf,trim.ht.CLalpha, trim.ht.alpha0,trim.ht.t_c,trim.ht.x_c_max] = airfoil_properties(aircraft.ht,aircraft.amb,Vg);
% 
% % Salvar propriedades na variáveis globais
% Clalpha_inf_w = trim.wing.Clalpha_inf; 
% CLalpha_w = trim.wing.CLalpha; 
% alpha0_w = trim.wing.alpha0; 
% t_c_w = trim.wing.t_c; 
% x_c_max_w = trim.wing.x_c_max;
% 
% Clalpha_inf_ht = trim.ht.Clalpha_inf; 
% CLalpha_ht = trim.ht.CLalpha; 
% alpha0_ht = trim.ht.alpha0; 
% t_c_ht = trim.ht.t_c; 
% x_c_max_ht = trim.ht.x_c_max;
% 
% %%  Parâmetros cte
%  
% %de_dalpha (Ddownwash/Dalpha_w)
% % Ref. Etkin (Ap. B5) p.332
% K_A = 1/aircraft.wing.AR-1/(1+aircraft.wing.AR^1.7);
% K_lambda = (10-3*aircraft.wing.lambda)/7;
% K_H = (1-abs(aircraft.ht.Zac/aircraft.wing.span))/((2*aircraft.ht.Lht/aircraft.wing.span)^(1/3)); % definir o ht.Zac
% de_dalpha = (4.44*(K_A*K_lambda*K_H*cos(aircraft.wing.sweep14*(pi/180)))^1.19);  
% 
% % Especificado a margem estática - encontra-se o Cmalpha_cg
% trim.Cmalpha = -aircraft.general.SM*trim.wing.CLalpha;
% 
% % Xcg calculado
% aux =  aircraft.ht.eta*(aircraft.ht.S/aircraft.wing.S)*trim.ht.CLalpha*(1-de_dalpha);     
% trim.Xcg_MAC = (trim.Cmalpha+trim.wing.CLalpha*(aircraft.wing.Xac/aircraft.wing.MAC)+aux*(aircraft.ht.Xac/aircraft.wing.MAC))/(trim.wing.CLalpha+aux) %**
% 
% 
% %% Verificação de Cm0 > 0 em deltae=0
% 
% alpha_w=trim.wing.alpha0; % Aproximação por CLw=0- maior contribuição ao CL
% deltae=0;
% dCL=0;
% alpha_ht = alpha_w + alpha_w*(de_dalpha*(pi/180))+(aircraft.ht.i-aircraft.wing.i);
% trim.wing.polars = generate_polars(aircraft.wing,aircraft.amb,Vg,alpha_w,1); % call lifting line function for the wing
% trim.ht.polars = generate_polars(aircraft.ht,aircraft.amb,Vg,alpha_ht,2); % call lifting line function for the ht
% 
% % Aqui antecipei a parte da análise gráfica para chamar airfoil_Cm0 uma
% % única vez
% alpha_waux = [alphai_w:dalpha_w:alphaf_w] %**
% Cm0_aux = airfoil_Cm0(aircraft.wing,aircraft.amb,Vg,alpha_waux) %**
% Cm0_0L = interp1(alpha_waux,Cm0_aux, alpha_w,'PCHIP','extrap')%**
% 
% % Cm0 no ângulo alpha_w e Re específico
% trim.wing.Cm0 = Cm0_0L %** 
% %trim.wing.Cm0 = airfoil_Cm0(aircraft.wing,aircraft.amb,Vg,alpha_w); 
% trim.wing.Cm = trim.wing.Cm0*((aircraft.wing.AR*(cos(aircraft.wing.sweep14*(pi/180)))^2)/(aircraft.wing.AR+2*cos(aircraft.wing.sweep14*(pi/180))));
% 
% % Cm_cg_total - sem o termo de deflexão de flap da asa (delta_f=0)/sem fuselagem e propulsão   
% trim.Cm0 = trim.wing.polars.CL*(trim.Xcg_MAC-aircraft.wing.Xac/aircraft.wing.MAC)+trim.wing.Cm-aircraft.ht.eta*(aircraft.ht.S/aircraft.wing.S)*(trim.ht.polars.CL+dCL)*(aircraft.ht.Xac/aircraft.wing.MAC-trim.Xcg_MAC)%**
% %CL total para a deflexão deltae e alpha_w
% CL_total_Cm0=trim.wing.CLalpha*(alpha_w-trim.wing.alpha0)*(pi/180)+aircraft.ht.eta*(aircraft.ht.S/aircraft.wing.S)*(trim.ht.polars.CL+dCL)%**
% 
% %% Método gráfico - plotagem de Cmcg x CL total e verificação do deltae para
% % Cmcg = 0
% 
% % consigo calcular vetorialmente
% alpha_w = [alphai_w:dalpha_w:alphaf_w];
% % Ângulo de ataque do HT
% alpha_ht = alpha_w + alpha_w*(de_dalpha*(pi/180))+(aircraft.ht.i-aircraft.wing.i);
% 
% % Cm0 no ângulo alpha_w e Re específico
% %trim.wing.Cm0 = airfoil_Cm0(aircraft.wing,aircraft.amb,Vg,alpha_w); 
% trim.wing.Cm0 = Cm0_aux %**
% trim.wing.Cm = (trim.wing.Cm0).*((aircraft.wing.AR*(cos(aircraft.wing.sweep14*(pi/180)))^2)/(aircraft.wing.AR+2*cos(aircraft.wing.sweep14*(pi/180))));
% 
% j=1;  % controlar a posição dos CL(s) que zeram Cmcg
% i=1;
% %trim.wing.polars = zeros(1,length(alpha_w));
% %trim.ht.polars = zeros (1,length(alpha_w));
% for alpha_w = alphai_w:dalpha_w:alphaf_w
%      trim.wing.polars(i) = generate_polars(aircraft.wing,aircraft.amb,Vg,alpha_w,1); % call lifting line function for the wing
%      trim.ht.polars(i) = generate_polars(aircraft.ht,aircraft.amb,Vg,alpha_ht(i),2); % call lifting line function for the ht
%      trim.wing.polars(i) %**
%      i=i+1
% end
% 
% if trim.Cm0 > 0
%      
%     %CL_trim_graf =zeros(1,2);
%     %alpha_w_trim_graf = zeros(1,2);
%     for deltae = deltae_min:ddeltae:deltae_max
% 
%         %Aumento do Cl no HT devido a deflexão deltae
%         dCL = deltaCL(deltae, aircraft.ht,trim.ht.t_c);
%         i=1;
%         %trim.Cm = zeros(1,2);
%         %trim.CL_total = zeros(1,2);
%         for alpha_w = alphai_w:dalpha_w:alphaf_w
%             
%             % Cm_cg_total - sem o termo de deflexão de flap da asa (delta_f=0)/sem fuselagem e propulsão   
%             trim.Cm(i) = trim.wing.polars(i).CL*(trim.Xcg_MAC-aircraft.wing.Xac/aircraft.wing.MAC)+trim.wing.Cm(i)-aircraft.ht.eta*(aircraft.ht.S/aircraft.wing.S)*(trim.ht.polars(i).CL+dCL)*(aircraft.ht.Xac/aircraft.wing.MAC-trim.Xcg_MAC);
% 
%             %CL total para a deflexão deltae e alpha_w
%             trim.CL_total(i)=trim.wing.CLalpha*(alpha_w-trim.wing.alpha0)*(pi/180)+aircraft.ht.eta*(aircraft.ht.S/aircraft.wing.S)*(trim.ht.polars(i).CL+dCL);
% 
%             i=i+1;       
%         end      
% 
%         % Avalio o CL de trimagem (Cm = 0) para o deltae específico
%         CL_trim_graf(j) = interp1(trim.Cm,trim.CL_total,0,'linear','extrap'); % avalio o gráfico com eixos invertidos CL(Cm=0)
%         alpha_wtrim = [alphai_w:dalpha_w:alphaf_w];
%         alpha_w_trim_graf(j) = interp1(trim.CL_total,alpha_wtrim,CL_trim_graf(j),'linear','extrap');
%        
%         %Gráficos
%         figure
%         plot(trim.CL_total,trim.Cm,'*')
%         hold on
%         plot(trim.CL_total,trim.Cm)
%         plot(CL_trim_graf(j),0,'+')
%         grid on
%         
%         j=j+1;
% 
%     end
% 
%     deltae = [deltae_min:ddeltae:deltae_max];
%     trim.ht.deltae_trim = interp1(CL_trim_graf,deltae,trim.CL_trim,'linear','extrap');
%     trim.wing.alpha_trim = interp1(CL_trim_graf,alpha_w_trim_graf,trim.CL_trim,'linear','extrap');
%     trim.ht.alpha_trim = trim.wing.alpha_trim + trim.wing.alpha_trim*(de_dalpha*(pi/180))+(aircraft.ht.i-aircraft.wing.i);
%     trim.CDi = trim.wing.polars(1).K*(trim.wing.CLalpha*(trim.wing.alpha_trim-trim.wing.alpha0)*(pi/180))^2+aircraft.ht.eta*(aircraft.ht.S/aircraft.wing.S)*trim.ht.polars(1).K*(trim.ht.CLalpha*(trim.ht.alpha_trim-trim.ht.alpha0)*(pi/180)+dCL)^2; 
% 
%     
%     %gráfico
%     trim.wing.polars(1).K
%     trim.ht.polars(1).K
%     
%     
% else 
%    trim.CDi =10; % Valor absurdo de CDi para prejudicar a avaliação da aeronave instável 
%     
% end

