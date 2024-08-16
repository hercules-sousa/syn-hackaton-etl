from lxml import etree

parser = etree.XMLParser(recover=True)
xml_tree = etree.parse('xml/XML_ORACLE_CLOUD.xml', parser)

xslt_tree = etree.parse('template.xsl')

transform = etree.XSLT(xslt_tree)
transformed_tree = transform(xml_tree)

output_file = 'transformed.xml'
with open(output_file, 'wb') as f:
    f.write(etree.tostring(transformed_tree, pretty_print=True))