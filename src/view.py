from flask import Flask, request, jsonify
from flask_cors import CORS

import service

app = Flask(__name__)
CORS(app)

@app.route('/transformaXml', methods=['POST'])
def transforma_xml():
    try:
        dados = request.json
        service.funcao(dados)
        return jsonify({'status': 'sucesso', 'mensagem': 'Operação concluida com sucesso!'})
    except Exception as e:
        return jsonify({'status': 'falha', 'mensagem': 'Erro ao acessar os dados!'})