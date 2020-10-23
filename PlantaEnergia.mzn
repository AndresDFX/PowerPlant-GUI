%LECTURA DE DATOS
int: n; % numero de dias
int: s; % numero de clientes
array[1..3] of var int: CP; % capacidad de produccion diaria de cada central
array[1..3] of var int: CC; % costo por producir 1 MW en cada central (CN,CH,CT)
array[1..s, 1..n] of int: d; % matriz de demanda diaria en MW de la lista de clientes

%VARIABLES
array[1..3, 1..n] of var int: MW; % matriz representa cuantos MW por maquina se escojen para satisfacer la demanda diaria de todos los clientes s,en un horizonte de n dias 
 
%RESTRICCIONES
%No negatividad


%Capacidad de produccion


%FUNCION OBJETIVO
%Escoger de las 3 plantas la que cumpla con la demanda diaria de todos los clientes n a un menor costo