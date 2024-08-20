import React, { useState } from 'react';
import { getDados, postDados, deleteDados, updateDados } from './services/service';
import { tagsDestino} from './constantes'
import styles from './App.module.css'
import Switch from '@mui/material/Switch'
import { Button, Fab, FormControlLabel, TextField } from '@mui/material';
import { AddAlarm, AddBox, AddIcCallOutlined } from '@mui/icons-material';

function App() {
  const lista = tagsDestino; // Exemplo de lista
  const [formData, setFormData] = useState([{ nome: '', valor: '', isExpression: false, isDate: false }]);

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

  function handleRadioIsExpressionChange(index) {
    const newFormData = [...formData];
    //console.log(event.target.checked);
    newFormData[index].isExpression = event.target.checked;
    newFormData[index].isDate = event.target.checked 
      ? false
      : newFormData[index].isDate;
    setFormData(newFormData);
  };

  function handleRadioIsDateChange(index) {
    const newFormData = [...formData];
    //console.log(event.target.checked);
    newFormData[index].isDate = event.target.checked;
    newFormData[index].isExpression = event.target.checked 
      ? false
      : newFormData[index].isExpression;
    setFormData(newFormData);
  };

  function addInputs() {
    setFormData([...formData, { nome: '', valor: '', isExpression: false, isDate: false }]);
  };

  function handleSubmit() {
    event.preventDefault();
    console.log(formData)
    

    // if (!xmlFile) {
    //   alert('Por favor, selecione um arquivo XML.');
    //   return;
    // }

    // const data = new FormData();
    // console.log([...formData].map(({disabled, ...resto}) => {return resto}))
    // data.append('list', [...formData].map(({disabled, ...resto}) => {return resto}))
    // data.append('file', xmlFile);
    
    const data = [...formData].reduce((array, { nome, valor, isExpression, isDate }) => {
      array[nome] = {valor: valor, isExpression: isExpression, isDate: isDate};
      return array;
    }, {})
    
    postDados(data);
    
    //console.log(data); // Substitua isso pelo código de envio ao backend
    // Exemplo de envio ao backend:
    // fetch('https://seu-backend.com/api', {
    //   method: 'POST',
    //   headers: { 'Content-Type': 'application/json' },
    //   body: JSON.stringify(formData)
    // });
  };
  //console.log(formData)
  return (
    <>
      <header className={styles.header}>Bytes and Bugs Inc.</header>
      <form className={styles.container} onSubmit={handleSubmit}>
        {formData.map((item, index) => (
          <div key={index} className={styles.row}>
            <TextField 
              id="nome"
              color="secondary"
              label="Nome" 
              variant="outlined"
              size="small"
              value={item.nome}
              onChange={(e) => handleInputNameChange(index, e.target.value)}
            />
            <TextField 
              id="value"
              color="secondary"
              label={item.isDate ? '' : 'Valor'}
              type={item.isDate ? 'date' : 'text'}
              variant="outlined"
              size="small"
              value={item.valor}
              onChange={(e) => handleInputValueChange(index, e.target.value)}
            />
            <FormControlLabel 
              control={
                <Switch
                  checked={item.isExpression}
                  onChange={(e) => {handleRadioIsExpressionChange(index)}}
                  inputProps={{ 'aria-label': 'controlled' }}
                  color="secondary"
                />}   
              label="É uma expressão?" />

            <FormControlLabel 
              control={
                <Switch
                  checked={item.isDate}
                  onChange={(e) => {handleRadioIsDateChange(index)}}
                  inputProps={{ 'aria-label': 'controlled' }}
                  color="secondary"
                />}   
              label="É uma data?" />
          </div>
        ))}
        <Fab color="secondary" aria-label="add" onClick={addInputs}>
          <AddBox />
        </Fab>
        <Button type="submit" color="secondary" variant="contained">Converter XML</Button>
      </form>
    </>
  );
}

export default App;
