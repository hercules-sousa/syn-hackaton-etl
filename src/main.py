import os
import requests
import io
import re
from lxml import etree
from dotenv import load_dotenv


load_dotenv()


def extract_encoding(xml_string):
    match = re.search(
        r'^<\?xml[^>]*encoding=["\']([^"\']*)["\']', xml_string, re.IGNORECASE)

    if match:
        return match.group(1)
    else:
        return 'UTF-8'

requests.post('{}/xml-files/reset'.format(os.getenv('BASE_URL')))

for _ in range(12):
    body = {'id': '', 'nfs': []}
    response = requests.get('{}/xml-files'.format(os.getenv('BASE_URL')))
    body['id'] = response.json()['id']
    xml_files = response.json()['content']
    xml_encoding = extract_encoding(xml_files)
    parser = etree.XMLParser(recover=True)
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

        body['nfs'].append(etree.tostring(transformed_tree))

    post_res = requests.post('{}/xml-files'.format(os.getenv('BASE_URL')), data=body)
    print(post_res.json())

time_response = requests.get('{}/xml-files/time'.format(os.getenv('BASE_URL')))
print(time_response.content)
