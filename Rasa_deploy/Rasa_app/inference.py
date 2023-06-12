import logging
import flask
from flask import Flask, request, Response
import json
import os
import asyncio

from rasa.core.agent import Agent
from rasa.shared.utils.io import json_to_string


class Model:
    def __init__(self, model_path) -> None:
        self.agent = Agent.load(model_path)
        logging.info('Model added')

    def message(self, msg):
        msg = msg.strip()
        #result = asyncio.run(self.agent.parse_message_using_nlu_interpreter(msg))

        result = asyncio.run(self.agent.handle_text(msg))
        return json_to_string(result)
    
MODEL_PATH = "./models/model.tar.gz"

model = Model(MODEL_PATH)

app = Flask(__name__)

@app.route('/ping', methods=['GET'])
def ping():
    try:
        status = 200
        logging.info("Status 200")

    except Exception as e:
        print(e)
        status = 400

    return Response(response=json.dumps('Pong'), status=status, mimetype='application/json')

@app.route('/invocations', methods = ['POST'])
def transformation():
    try:
        input_json = request.get_json()
        inp = input_json['input']
        res = model.message(inp)

        return res
    except Exception as e:
        print("Error: e")

if __name__ == "__main__":
    port = 8080
    app.run(debug=True, host='0.0.0.0', port=port)