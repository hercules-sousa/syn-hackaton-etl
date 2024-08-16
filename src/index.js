const fs = require("fs");
const path = require("path");
const { DOMParser, XMLSerializer } = require("xmldom");

const config = require("../config.json");

const preffix = "syn_nota_simplificada";

const inputXmlPath = path.join(__dirname, "..", "xml", `${preffix}.xml`);
const modelXmlPath = path.join(
  __dirname,
  "..",
  "xml",
  "model",
  `${preffix}_modelo.xml`
);

const inputXml = fs.readFileSync(inputXmlPath, "utf8");
const modelXml = fs.readFileSync(modelXmlPath, "utf8");

const parser = new DOMParser();
const inputXmlDoc = parser.parseFromString(inputXml, "text/xml");
const modelXmlDoc = parser.parseFromString(modelXml, "text/xml");

config.tagMapping.forEach((mapping) => {
  const sourceTags = inputXmlDoc.getElementsByTagName(mapping.source);
  const destinationTags = modelXmlDoc.getElementsByTagName(mapping.destination);

  for (let i = 0; i < sourceTags.length; i++) {
    destinationTags[i].textContent = sourceTags[i].textContent;
  }
});
config.tagConcat.forEach((mapping) => {
  const destinationTags = modelXmlDoc.getElementsByTagName(mapping.destination);

  for (let i = 0; i < destinationTags.length; i++) {
    let concatenatedValue = "";
    mapping.source.forEach((sourceTag) => {
      const sourceElements = inputXmlDoc.getElementsByTagName(sourceTag);
      if (sourceElements.length > 0) {
        concatenatedValue += sourceElements[0].textContent + " "; // Adiciona um espaço como separador
      }
    });
    destinationTags[i].textContent = concatenatedValue.trim(); // Remove espaços em branco extras
  }
});

config.tagCondicion.forEach((condition) => {
  const destinationTags = modelXmlDoc.getElementsByTagName(
    condition.destination
  );

  for (let i = 0; i < destinationTags.length; i++) {
    let meetsCondition = false;

    condition.condicionIgualdadeValor.forEach((cond) => {
      const [tagToSearch, comparisonValue, valueIfTrue] = cond;
      const elementToSearch = inputXmlDoc.getElementsByTagName(tagToSearch)[0];
      if (elementToSearch && elementToSearch.textContent === comparisonValue) {
        destinationTags[i].textContent = valueIfTrue;
      }
    });
  }
});

config.tagDiferenca.forEach((condition) => {
  const destinationTags = modelXmlDoc.getElementsByTagName(
    condition.destination
  );

  for (let i = 0; i < destinationTags.length; i++) {
    const [tagToSearch, comparisonValue] = condition.condicionDiferenca;
    const elementToSearch = inputXmlDoc.getElementsByTagName(tagToSearch)[0];
    console.log(comparisonValue);
    console.log(elementToSearch.textContent);

    if (elementToSearch) {
      if (elementToSearch.textContent !== comparisonValue) {
        const valueToAssign = inputXmlDoc.getElementsByTagName(
          condition.valueIfTrue[0]
        )[0].textContent;
        console.log(valueToAssign);
        destinationTags[i].textContent = valueToAssign;
      } else {
        const valueToAssign = inputXmlDoc.getElementsByTagName(
          condition.valueIfFalse[0]
        )[0].textContent;
        destinationTags[i].textContent = valueToAssign;
      }
    }
  }
});

const serializer = new XMLSerializer();
const outputXmlString = serializer.serializeToString(modelXmlDoc);

const destinationPath = path.join(
  __dirname,
  "..",
  "xml",
  "transformed",
  `${preffix}_transformada.xml`
);
fs.writeFileSync(destinationPath, outputXmlString);
