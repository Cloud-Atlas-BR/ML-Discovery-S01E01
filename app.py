import joblib
import sklearn
import json

def handler(event, context):

    dados = list(event["data"])
    modelo = joblib.load("modelo.joblib")
    resposta = int(modelo.predict([dados]))

    return {

        'statusCode': 200,
        'body': resposta
    }
