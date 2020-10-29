#!/usr/bin/python
# -*- coding: utf-8 -*-
from flask import Flask, render_template, request, json, send_from_directory
from minizinc import Instance, Model, Solver
import re

app = Flask(__name__)


@app.route('/')
def index():
    return render_template('index.html')

@app.route('/model', methods=['POST', 'GET'])
def model():
    if request.method == 'POST':
        data = request.get_json()
        instance = format_data(data)
        result = solver(instance)
        # Crear archivo
        write_file_dzn(instance)
        if result:  
            return json.dumps({"data": {
                "costo": result['costo'],
                "MW": result['MW']
            }})
        else:
            return json.dumps({'message': 'Insatisfactible'})
            
    if request.method == 'GET':
        return send_from_directory('./static/files', 'datos.dzn', as_attachment=True)


def format_data(data):
    """
    Parametros de entrada del modelo
    """
    params = dict()
    params['n'] = int(data.get('n'))
    params['s'] = int(data.get('s'))
    params['CP'] = list(map(float, data.get('cp').split(' ')))
    params['CC'] = list(map(float, data.get('cc').split(' ')))
    
    d = list()
    for row in data.get('d').values():
        d.append(list(map(float, row)))
    params['d'] = d

    return params

def solver(data):
    """
    Ejecucion del modelo en minizinc
    """
    # Configurar modelo y solver
    planta_energia = Model("./model/PlantaEnergia.mzn")
    coinbc = Solver.lookup("coin-bc")
    instance = Instance(coinbc, planta_energia)
    # Configurar parametros de entrada
    instance["n"] = data['n']
    instance["s"] = data['s']
    instance["CP"] = data['CP']
    instance["CC"] = data['CC']
    instance["d"]= data['d']
    # Resultado modelo
    result = instance.solve()
    print("Resultado MiniZinc:", result)
    return result

def write_file_dzn(data):
    with open('./static/files/datos.dzn', 'w',) as file:
        file.write("%  Formato de entrada de datos para el problema Planta de Energias \n")
        file.write("%  Numero de Dias para produccion de energia \n")
        file.write("n={}; \n".format(data['n']))
        file.write("%  Numero de clientes \n")
        file.write("s={}; \n".format(data['s']))
        file.write("%  Capacidad de produccion diaria en MW \n")
        file.write("CP={}; \n".format(data['CP']))
        file.write("%  Costo de produccion de 1 MW para cada central \n")
        file.write("CC={}; \n".format(data['CC']))
        file.write("%  Demanda diaria de MW para s cliente hasta n dias \n")
        file.write("d=[{}]; \n".format(format_matriz(data['d'])))

def format_matriz(data):
    aux = str(data)
    aux = re.sub(r'\[\[','|', aux)
    aux = re.sub(r']]','|', aux)
    aux = re.sub(r'],','|', aux)
    aux = re.sub(r'\[','', aux)
    return aux


if __name__ == '__main__':
    app.run(host = '0.0.0.0')