
from lxml import etree

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
        f.write(etree.tostring(transformed_tree,
                pretty_print=True, xml_declaration=True))
