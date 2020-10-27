% LECTURA DE DATOS
int: n; % numero de dias
int: s; % numero de clientes
array[1..3] of int: CP; % capacidad de produccion diaria de cada central
array[1..3] of float: CC; % costo por producir 1 MW en cada central (CN,CH,CT)
%array[1..s, 1..n] of int: d; % matriz de demanda diaria en MW de la lista de clientes

% VARIABLES
% matriz representa cuantos MW por maquina se escojen para satisfacer 
% la demanda diaria de todos los clientes s,en un horizonte de n dias 
% array[1..3, 1..n] of var int: MW;

% RESTRICCIONES
%No negatividad
%Capacidad de produccion


%FUNCION OBJETIVO
%Escoger de las 3 plantas la que cumpla con la demanda diaria de todos los clientes n a un menor costo

% -------------------------------------------------------
array[1..n] of int: d;
% Haciendolo para 1 dia son tres variables
% Indican la cantidad de energia producida por cada planta N, H, T 
array[1..3] of var int: MW;
 
% Restricciones para 1 dia
% Restriccion de capacidad de produccion
constraint forall(i in 1..3)(MW[i] <= CP[i]);
% Restriccion demanda cliente para 1 dia
constraint sum(i in 1..3)(MW[i]) >= sum(i in 1..n)(d[i]);
% Restriccion no negatividad
constraint forall(i in 1..3)(MW[i] >= 0);

% Funcion Objetivo 1 dia
% Minimizar el costo de produccion de energia
var float: costo;
constraint costo = sum(i in 1..3) (CC[i] * MW[i]);
solve minimize costo;