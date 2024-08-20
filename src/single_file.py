from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter
import json
from lxml import etree


def get_args():
    parser = ArgumentParser(allow_abbrev=False, description='',
                            formatter_class=ArgumentDefaultsHelpFormatter)

    parser.add_argument('--custom_tags', type=str, help='', default=None)

    return vars(parser.parse_args())


if __name__ == "__main__":
    args = get_args()
    with open(args['custom_tags']) as json_file:
        custom_tags = json.load(json_file)

    parser = etree.XMLParser(recover=True)
    xml_tree = etree.parse(open('xml/XML_Nfe_125176099_2024-08-02_15_08_379.xml'), parser)
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

        output_file = 'out/transformed_{}.xml'.format(index)
        with open(output_file, 'wb') as f:
            f.write(etree.tostring(transformed_tree,
                                   pretty_print=True, xml_declaration=True))