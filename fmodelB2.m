function VT = fmodelB2(Req)
% Status: Programado [x] Verificado [x] Validado [x]
B2 = load('curvesdata\B2modelpoints');

p=polyfit(B2.R_B2,B2.VT_B2,4);
VT=polyval(p,Req);

end