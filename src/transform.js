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
