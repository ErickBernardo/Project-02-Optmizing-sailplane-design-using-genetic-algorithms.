function VT = fmodelA1(Req)
% Status: Programado [x] Verificado [x] Validado [x]
A1 = load('curvesdata\A1modelpoints');

p=polyfit(A1.R_A1,A1.VT_A1,4);
VT=polyval(p,Req);

end