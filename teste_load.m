% teste load 

close all
clear all
clc




load('airfoildata\Cm0\e403.mat');

airfoil = e403; 

airfoil(:,1)




alpha = e403(:,1);

i= 1;
flag =0;
while flag == 0 &&  i < length(alpha)
    if  isnan(alpha(i)) == 1
        flag = 1;
    end
    i=i+1;
end

alpha = alpha(1:i-2,1);
cm = e403(1:i-2,2);

cm_int = interp1(alpha,cm,0,'PCHIP','extrap');

%x = {'xy','yz',nan}
% x(cellfun(@(x) any(isnan(x)),x)) = []


%cellfun(@(e403) strcmp(e403, 'NaN'), e403)
