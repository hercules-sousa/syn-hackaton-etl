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


parser = etree.XMLParser(recover=True)
xml_tree = etree.parse(open('xml/XML_ORACLE_CLOUD.xml'), parser)
xslt_tree = etree.parse('template.xsl')
transform = etree.XSLT(xslt_tree)

root = xml_tree.getroot()

if root.tag == 'FISCAL_DOC_HEADER':
    fiscal_docs = [root]

for index, fiscal_doc in enumerate(fiscal_docs):
    new_tree = etree.ElementTree(fiscal_doc)
    transformed_tree = transform(new_tree)

    output_file = 'out/transformed_{}.xml'.format(index)
    with open(output_file, 'wb') as f:
        f.write(etree.tostring(transformed_tree, pretty_print=True, xml_declaration=True))

# for _ in range(12):
#     response = requests.get('{}/xml-files'.format(os.getenv('BASE_URL')))
#     xml_id = response.json()['id']
#     xml_files = response.json()['content']
#     xml_encoding = extract_encoding(xml_files)
#     parser = etree.XMLParser(recover=True)
#     xml_tree = etree.parse(io.BytesIO(xml_files.encode(xml_encoding)))
#     xslt_tree = etree.parse('template.xsl')
#     transform = etree.XSLT(xslt_tree)

#     root = xml_tree.getroot()

#     if root.tag == 'FISCAL_DOC_HEADER':
#         fiscal_docs = [root]
#     else:
#         fiscal_docs = root.findall('FISCAL_DOC_HEADER')

#     for index, fiscal_doc in enumerate(fiscal_docs):
#         new_tree = etree.ElementTree(fiscal_doc)
#         transformed_tree = transform(new_tree)

#         output_file = 'out/transformed_{}_{}.xml'.format(xml_id, index)
#         with open(output_file, 'wb') as f:
#             f.write(etree.tostring(transformed_tree, pretty_print=True, xml_declaration=True))

#     requests.post('{}/xml-files/reset'.format(os.getenv('BASE_URL')))
