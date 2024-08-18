from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter
from lxml import etree


def get_args():
    parser = ArgumentParser(allow_abbrev=False, description='',
                            formatter_class=ArgumentDefaultsHelpFormatter)
    parser.add_argument('--xml_file', type=str, default=None)

    return vars(parser.parse_args())


args = get_args()

parser = etree.XMLParser(recover=True)
xml_tree = etree.parse(args['xml_file'], parser)
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

    output_file = 'out/transformed_{}.xml'.format(index)
    with open(output_file, 'wb') as f:
        f.write(etree.tostring(transformed_tree,
                               pretty_print=True, xml_declaration=True))
