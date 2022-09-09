function VT = fmodelB1(Req)
% Status: Programado [x] Verificado [x] Validado [x]
B1 = load('curvesdata\B1modelpoints');

p=polyfit(B1.R_B1,B1.VT_B1,4);
VT=polyval(p,Req);

end