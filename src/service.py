from simpleeval import simple_eval
from lxml import etree

import json
from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter

import gateway
import re
import io

def trata_exepressao(root, request_content):
    pattern = r"\{(.*?)\}"

    variaveis = re.findall(pattern, request_content)
    names = {}

    for variavel in variaveis:
        variavel_sep = variavel.split('/')
        names["".join(variavel_sep)] = find_tag_value(root, variavel_sep)
        request_content = request_content.replace(f"{{{variavel}}}", "".join(variavel_sep))

    return simple_eval(request_content, names=names)


def find_tag_value(root, tag_path):
    tag_atual = root

    for tag_xml in tag_path:
        tag_atual = tag_atual.find(tag_xml)

    return tag_atual.text

def tags_parametrizadas(root, dados):
    dic = {}
    for key, value in dados.items():
        valor = value["value"]
        if value["isExpression"]:
            dic[key] = trata_exepressao(root, valor)
        else:
            dic[key] = valor

    return dic

def extract_encoding(xml_string):
    match = re.search(
        r'^<\?xml[^>]*encoding=["\']([^"\']*)["\']', xml_string, re.IGNORECASE)

    if match:
        return match.group(1)
    else:
        return 'UTF-8'

def funcao(dados):
    reset_res = gateway.reset_xml()
    print(reset_res.content)

    for _ in range(12):
        body = {'id': '', 'nfs': []}
        response = gateway.get_xml()
        body['id'] = response.json()['id']
        xml_files = response.json()['content']
        xml_encoding = extract_encoding(xml_files)
        xml_tree = etree.parse(io.BytesIO(xml_files.encode(xml_encoding)))

        xslt_tree = etree.parse('../template.xsl')
        transform = etree.XSLT(xslt_tree)

        root = xml_tree.getroot()

        if root.tag == 'FISCAL_DOC_HEADER':
            fiscal_docs = [root]
        else:
            fiscal_docs = root.findall('FISCAL_DOC_HEADER')

        for index, fiscal_doc in enumerate(fiscal_docs):
            new_tree = etree.ElementTree(fiscal_doc)
            transformed_tree = transform(new_tree)

            ns = {'nfe': 'http://www.synchro.com.br/nfe'}
            custom_tags = tags_parametrizadas(new_tree.getroot(), dados)

            rps_element = transformed_tree.find('.//nfe:RPS', namespaces=ns)

            for key, value in custom_tags.items():
                element = etree.Element(key)
                element.text = str(value)
                rps_element.append(element)

            body['nfs'].append(etree.tostring(
                transformed_tree).decode(xml_encoding))

        post_res = gateway.post_xml(body)