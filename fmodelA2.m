function VT = fmodelA2(Req)
% Status: Programado [x] Verificado [x] Validado [x]
A2 = load('curvesdata\A2modelpoints');

p=polyfit(A2.R_A2,A2.VT_A2,4);
VT=polyval(p,Req);

end