% Execução GA


global H;
global ngeom pgeom;

tic

for i=1:1:1

    ngeom=0;
    
    s = rng;
    Hi=2100;
    Hf=2900;
    dH =100;

    for H = Hi:dH:Hf
        
        rng(s);
        % AG  
        gaoptm 
        
        number = num2str(i);
        file = strcat(number,'H')

        h = num2str(H);
        filename = strcat(file, h); 
        save(filename,'res','fval','exitflag','output','population','scores','H','ngeom');


    end    

end

toc