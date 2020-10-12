%LECTURA DE DATOS
int: n; % numero de dias
int: s; % numero de clientes
array[1..3] of var int: CP; % capacidad de produccion diaria de cada central
array[1..s] of int: c; % lista de clientes
array[1..s] of int: d; % demanda diaria en MW de la lista de clientes

%VARIABLES
var int: CN; % costos de produccion por cada MW de la central Nuclear
var int: CH; % costos de produccion por cada MW de la central Hidroelectrica
var int: CT; % costos de produccion por cada MW de la central Termica

%RESTRICCIONES
%No negatividad
constraint CN >= 0;
constraint CH >= 0;
constraint CT >= 0;

%FUNCION OBJETIVO
%Escoger de las 3 plantas la que cumpla con la demanda diaria a un menor costo