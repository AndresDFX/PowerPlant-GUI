% LECTURA DE DATOS
% Número de dias
int: n;
% Número de clientes 
int: s;
% Capacidad de producción diaria de cada central
array[1..3] of float: CP; 
% Costo por producir 1 MW en cada central (CN,CH,CT)
array[1..3] of float: CC; 
%array[1..s, 1..n] of int: d; % matriz de demanda diaria en MW de la lista de clientes
array[1..n] of float: d;

% VARIABLES
% Indica la cantidad de MW a producir en cada central (caso para 1 cliente)
array[1..n, 1..3] of var float: MW;

% RESTRICCIONES
% Restricción de capacidad de producción
constraint forall(i in 1..n, j in 1..3) (MW[i,j] <= CP[j]);
% Restricción demanda diaria para 1 cliente
constraint forall(i in 1..n) (d[i] <= sum(j in 1..3)(MW[i, j]));
% Restricción no negatividad
constraint forall(i in 1..n, j in 1..3)(MW[i,j] >= 0);


%FUNCIÓN OBJETIVO
% Minimizar el costo de producción de energia (caso para 1 cliente)
var float: costo;
constraint costo = sum(i in 1..n, j in 1..3) (MW[i, j] * CC[j]);
solve minimize costo;
