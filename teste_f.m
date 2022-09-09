% Teste f /  performance analysis

%% Aircraft 1


% Input aircraft   - Modelo SGS 135 (coluna AM - excel)
ARw = 23.3;
bw=15;
lambdaw = 0.4;
airfoil_w = 3;
twist=-4;
xw=0.15;
tail_arrang=3;
airfoil_ht=1;
AR_ht = 4.16;
b_ht=3.5;
lambda_ht=0.8;
W = 422;
SM = 0.10;
cf_c_ht=0.5;

p = [ARw, bw, lambdaw, airfoil_w, twist, xw, tail_arrang, airfoil_ht, AR_ht, b_ht, lambda_ht, W, SM, cf_c_ht];

%% Aircraft 2



%% Função f / performance analysis ok[x]   7:30 min de execução

fval = f(p);

Vavg_media = -fval


