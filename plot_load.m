function [ ] = plot_load( geometry, amb, Vinf, polars )
% Status: Programado [x] Verificado [] Validado []
%Plot load distribution

n = length(polars.theta)+2;

for i=1:n-2,
	Gamma(i)=2*geometry.span*Vinf*sum(polars.A(:).*(sin([1:n-2]*polars.theta(i)))');
end;
Gamma = [0;Gamma(:);0];

Cl=(2*Gamma)./(polars.c/Vinf);
l=amb.rho*Vinf*Gamma;	% N/m
plot(polars.y,polars.c.*Cl); 
ylabel('c*Cl');
xlabel('y [m]');


end

