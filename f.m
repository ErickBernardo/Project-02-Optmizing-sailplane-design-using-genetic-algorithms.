function fval = f(p)
% Status: Programado [x] Verificado [x] Validado [x]
% Objetivo: Fun��o a ser otimizada ( m�nimo = -Vavg  : Vavg: average cross country speed no modelo de Cast)

global Vcd0_int;
global CD0_int;
global K_int;
global V_trim;


%% Defini��o dos parametros de entrada na estrutura aircraft
aircraft = read_from_parameters(p); 

%% Aerodynamica

% Cria vari�veis globais de interpola��o de CD0 e K (na trimagem)
polares(aircraft)

%% Performance analysis

performance.climb = climb_analysis(aircraft,@fmodelA1,@fmodelA2,@fmodelB1,@fmodelB2);

performance.glide = glide_analysis(aircraft,performance.climb);

%% Quast's model - Ref. Fred. Thomas - Sailplane Design
a=0.08;
b=0.42;
c=0.08;
d=0.42;

% Miniziar -resp
fval = -1/((a/performance.glide.Vavg_maxA1)+(b/performance.glide.Vavg_maxA2)+(c/performance.glide.Vavg_maxB1)+(d/performance.glide.Vavg_maxB2));



end






