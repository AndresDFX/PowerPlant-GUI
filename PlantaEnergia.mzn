% LECTURA DE DATOS
% Número de dias
int: n;
% Número de clientes 
int: s;
% Capacidad de producción diaria de cada central
array[1..3] of float: CP; 
% Costo por producir 1 MW en cada central (CN,CH,CT)
array[1..3] of float: CC; 
% Demanda diaria en MW de cada cliente
% Filas -> Clientes
% Columnas -> Dias
array[1..s, 1..n] of float: d; 


% VARIABLES
% Indica la cantidad de MW a producir en cada central
% Filas -> Centrales electricas
% Columnas -> Dias
array[1..3, 1..n] of var float: MW;

% RESTRICCIONES
% Restricción de capacidad de producción
constraint forall(i in 1..3, j in 1..n) (MW[i,j] <= CP[i]);
% Restricción demanda diaria para cada cliente
constraint forall(j in 1..n) (sum(i in 1..s)(d[i, j]) <= sum(i in 1..3)(MW[i, j]));
% Restricción no negatividad
constraint forall(i in 1..3, j in 1..n)(MW[i,j] >= 0);

% FUNCIÓN OBJETIVO
% Minimizar el costo de produccion de energia
var float: costo;
constraint costo = sum(i in 1..3, j in 1..n) (MW[i, j] * CC[i]);
solve minimize costo;

% Ejecutar con COIN_BC