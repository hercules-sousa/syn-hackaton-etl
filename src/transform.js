const fs = require("fs");
const xml2js = require("xml2js");

const inputXml = `
<ROOT>
    <ITEMX>
        <ID>1</ID>
        <NAME>ITEM 1</NAME>
    </ITEMX>
    <ITEMX>
        <ID>2</ID>
        <NAME>ITEM 2</NAME>
    </ITEMX>
</ROOT>
`;

const modelXmlString = `
<root>
    <itemX>
        <id></id>
        <name></name>
    </itemX>
    <itemX>
        <id></id>
        <name></name>
    </itemX>
</root>
`;

const config = {
  tagMapping: [
    {
      source: "ID",
      destination: "id",
    },
    {
      source: "NAME",
      destination: "name",
    },
  ],
};

// Parser para XML -> JS
const parser = new xml2js.Parser({ explicitArray: false });
const builder = new xml2js.Builder();

// Função para aplicar o mapeamento
function mapXmlValues(inputObj, modelObj, config) {
  const items = inputObj.ROOT.ITEMX;
  const modelItems = modelObj.root.itemX;

  items.forEach((item, index) => {
    config.tagMapping.forEach((mapping) => {
      modelItems[index][mapping.destination] = item[mapping.source];
    });
  });
}

parser.parseString(inputXml, (err, inputObj) => {
  if (err) throw err;

  parser.parseString(modelXmlString, (err, modelObj) => {
    if (err) throw err;

    mapXmlValues(inputObj, modelObj, config);

    const resultXmlString = builder.buildObject(modelObj);

    console.log(resultXmlString);

    // Opcional: Salva o resultado em um arquivo
    // fs.writeFileSync("output.xml", resultXmlString);
  });
});
