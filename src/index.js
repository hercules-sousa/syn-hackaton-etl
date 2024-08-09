const fs = require("fs");
const xml2js = require("xml2js");
const path = require("path");

const config = require("../config.json");

async function extract(filePath) {
  const parser = new xml2js.Parser();

  return new Promise((resolve, reject) => {
    fs.readFile(filePath, (err, data) => {
      if (err) {
        reject("An error occurred when reading XML file: " + err);
        return;
      }

      parser.parseString(data, (err, result) => {
        if (err) {
          reject("An error occurred when parsing XML file: " + err);
          return;
        }

        resolve(result);
      });
    });
  });
}

function replaceTags(obj, sourceTag, destinyTag) {
  if (typeof obj !== "object" || obj === null) return;

  if (Array.isArray(obj)) {
    obj.forEach((item) => replaceTags(item, sourceTag, destinyTag));
  } else {
    if (obj[sourceTag]) {
      obj[destinyTag] = obj[sourceTag];
      delete obj[sourceTag];
    }

    Object.keys(obj).forEach((key) => {
      replaceTags(obj[key], sourceTag, destinyTag);
    });
  }
}

function process(xml) {
  for (let mapping of config.tagMapping) {
    replaceTags(xml, mapping.source, mapping.destiny);
  }

  return xml;
}

function printXml(xml) {
  const builder = new xml2js.Builder();
  const updatedXML = builder.buildObject(xml);
  console.log(updatedXML);
}

function load(transformedXmlFile) {
  const folderPath = path.join(
    __dirname,
    "../xml/transformed",
    "processed.xml"
  );

  const builder = new xml2js.Builder();
  const updatedXML = builder.buildObject(transformedXmlFile);

  fs.writeFile(folderPath, updatedXML, (err) => {
    if (err) {
      console.error("An error occurred when saving XML file:", err);
      return;
    }
  });
}

(async () => {
  const filePath = path.join(__dirname, "../xml", "exemplo.xml");

  try {
    const xmlFile = await extract(filePath);

    const transformedXmlFile = process(xmlFile);

    printXml(transformedXmlFile);

    load(transformedXmlFile);
  } catch (err) {
    console.error(err);
  }
})();
