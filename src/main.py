import os
import requests
import io
import re
import json
from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter
from lxml import etree
from dotenv import load_dotenv


def get_args():
    parser = ArgumentParser(allow_abbrev=False, description='',
                            formatter_class=ArgumentDefaultsHelpFormatter)

    parser.add_argument('--custom_tags', type=str, help='', default=None)

    return vars(parser.parse_args())


def extract_encoding(xml_string):
    match = re.search(
        r'^<\?xml[^>]*encoding=["\']([^"\']*)["\']', xml_string, re.IGNORECASE)

    if match:
        return match.group(1)
    else:
        return 'UTF-8'


load_dotenv()

args = get_args()
with open(args['custom_tags']) as json_file:
    custom_tags = json.load(json_file)
reset_res = requests.post('{}/xml-files/reset'.format(os.getenv('BASE_URL')))
print(reset_res.content)

for _ in range(12):
    body = {'id': '', 'nfs': []}
    response = requests.get('{}/xml-files'.format(os.getenv('BASE_URL')))
    body['id'] = response.json()['id']
    xml_files = response.json()['content']
    xml_encoding = extract_encoding(xml_files)
    xml_tree = etree.parse(io.BytesIO(xml_files.encode(xml_encoding)))
    xslt_tree = etree.parse('template.xsl')
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

        rps_element = transformed_tree.find('.//nfe:RPS', namespaces=ns)

        for key, value in custom_tags.items():
            element = etree.Element(key)
            element.text = str(value)
            rps_element.append(element)

        body['nfs'].append(etree.tostring(
            transformed_tree).decode(xml_encoding))

    post_res = requests.post(
        '{}/xml-files'.format(os.getenv('BASE_URL')), json=body)

time_response = requests.get('{}/xml-files/time'.format(os.getenv('BASE_URL')))
print(time_response.content)
