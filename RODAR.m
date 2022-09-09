% Execução GA

tic

global H;
global ngeom pgeom;

ngeom=0;

%Hi=0;
%Hf=10000;
%dH = 500;

%for H = Hi:dH:Hf
 
H = 2500;

% AG  
gaoptm 

h = num2str(H);
filename = strcat('1H', h); 
save(filename,'res','fval','exitflag','output','population','scores','H','ngeom');
    
    
%end    

toc