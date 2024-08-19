import React, { useState } from 'react';
import { getDados, postDados2, deleteDados, updateDados } from './services/service';
import { tagsDestino} from './constantes'
import styles from './App.module.css'

function App() {
  const lista = tagsDestino; // Exemplo de lista
  const [formData, setFormData] = useState(lista.map(item => ({ nome: item, valor: '', disabled: true })));
  const [xmlFile, setXmlFile] = useState(null);

  function handleFileChange(e) {
    setXmlFile(e.target.files[0]);
  };

  function handleInputNameChange(index, value) {
    const newFormData = [...formData];
    newFormData[index].nome = value;
    setFormData(newFormData);
  };

  function handleInputValueChange(index, value) {
    const newFormData = [...formData];
    newFormData[index].valor = value;
    setFormData(newFormData);
  };

  function addInputs() {
    setFormData([...formData, { nome: '', valor: '', disabled: false }]);
  };

  function handleSubmit() {
    event.preventDefault();

    // if (!xmlFile) {
    //   alert('Por favor, selecione um arquivo XML.');
    //   return;
    // }

    // const data = new FormData();
    // console.log([...formData].map(({disabled, ...resto}) => {return resto}))
    // data.append('list', [...formData].map(({disabled, ...resto}) => {return resto}))
    // data.append('file', xmlFile);
    
    const data = [...formData].reduce((array, { nome, valor }) => {
      array[nome] = valor;
      return array;
    }, {})
    
    postDados2(data);
    
    console.log(data); // Substitua isso pelo código de envio ao backend
    // Exemplo de envio ao backend:
    // fetch('https://seu-backend.com/api', {
    //   method: 'POST',
    //   headers: { 'Content-Type': 'application/json' },
    //   body: JSON.stringify(formData)
    // });
  };

  return (
    <>
      <header className={styles.header}>Bytes and Bugs Inc.</header>
      <form className={styles.container} onSubmit={handleSubmit}>
        {formData.map((item, index) => (
          <div key={index} className={styles.row}>
            <input
              className={styles.input}
              value={item.nome}
              onChange={(e) => handleInputNameChange(index, e.target.value)}
              disabled={item.disabled}
              placeholder="nome"
            />
            <input
              className={styles.input}
              value={item.valor}
              onChange={(e) => handleInputValueChange(index, e.target.value)}
              placeholder="valor"
            />
          </div>
        ))}
        <input type="file" accept=".xml" onChange={handleFileChange} />
        <button type="button" className={styles.addButton} onClick={addInputs}>+</button>
        <button type="submit" className={styles.submitButton}>Enviar</button>
      </form>
    </>
  );
}

export default App;
