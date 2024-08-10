const { DOMParser, XMLSerializer } = require("xmldom");

const inputXmlString = `
<ROOT>
    <ITEMX>
        <ID>1</ID>
        <NAME>ITEM 1</NAME>
    </ITEMX>
    <ITEMX>
        <ID>2</ID>
        <NAME>ITEM 2</NAME>
    </ITEMX>
</ROOT>`;

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
</root>`;

const config = {
  tagMapping: [
    {
      source: "ID",
      destination: "id",
    },
  ],
};

const parser = new DOMParser();
const inputXmlDoc = parser.parseFromString(inputXmlString, "text/xml");
const modelXmlDoc = parser.parseFromString(modelXmlString, "text/xml");

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
