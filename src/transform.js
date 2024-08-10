const fs = require("fs");
const path = require("path");
const { DOMParser, XMLSerializer } = require("xmldom");

const config = require("../config.json");

const inputXmlPath = path.join(__dirname, "..", "xml", "exemplo.xml");
const input = fs.readFileSync(inputXmlPath, "utf8");

const modelXmlPath = path.join(
  __dirname,
  "..",
  "xml",
  "model",
  "exemplo_modelo.xml"
);
const model = fs.readFileSync(modelXmlPath, "utf8");

const parser = new DOMParser();
const inputXmlDoc = parser.parseFromString(input, "text/xml");
const modelXmlDoc = parser.parseFromString(model, "text/xml");

config.tagMapping.forEach((mapping) => {
  const sourceTags = inputXmlDoc.getElementsByTagName(mapping.source);
  const destinationTags = modelXmlDoc.getElementsByTagName(mapping.destination);

  for (let i = 0; i < sourceTags.length; i++) {
    destinationTags[i].textContent = sourceTags[i].textContent;
  }
});

const serializer = new XMLSerializer();
const outputXmlString = serializer.serializeToString(modelXmlDoc);

console.log(outputXmlString);

const destinationPath = path.join(
  __dirname,
  "..",
  "xml",
  "transformed",
  "processed.xml"
);
fs.writeFileSync(destinationPath, outputXmlString);
