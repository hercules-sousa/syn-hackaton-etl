// import styles from './App.module.css'

// function App() {
//   const lista = ['input', 'input', 'input', 'input'];
//   const lista2 = ['input', 'input', 'input'];

//   return(
//     <>
//       <header className={styles.header}>header</header>
//       <form action="">
//         <input className={styles.input} />
//         <div className={styles.container}>
//           <div className={styles.box}>
//             {lista.map(val => {
//               return (<input value={val} className={styles.input} />);
//             })}
//           </div>
//           <div className={styles.box}>
//             {lista2.map(val => {
//               return (<input value={val} className={styles.input} />);
//             })}
//           </div>
//         </div>
//       </form>
//     </>
//   );
// }

// export default App


// * {
//   margin: 0;
//   padding: 0;
//   box-sizing: border-box;
// }

// /* body {
//   font-family: Arial, sans-serif;
//   display: flex;
//   justify-content: center;
//   background-color: green;
// } */

// .header {
//   background: orange;
//   display: flex;
//   justify-content: center;
//   padding: 1.25rem 0;
// }

// .container {
//   display: flex;
//   background: red;
//   flex-direction: column;
//   gap: 20px; /* Espaçamento entre os elementos */
// }

// .box {
//   display: flex;
//   gap: 20px; /* Espaçamento entre os elementos */
// }

// .input {
//   background-color: #4CAF50;
//   color: white;
//   padding: 20px;
//   border-radius: 5px;
//   text-align: center;
//   flex: 1; /* Ajuste proporcional do tamanho dos elementos */
//   min-width: 100px; /* Largura mínima dos elementos */
// }

import React, { useState } from 'react';

const InputList = () => {
  const [inputs, setInputs] = useState([{ nome: '', valor: '' }]);

  const addInputs = () => {
    setInputs([...inputs, { nome: '', valor: '' }]);
  };

  const handleInputChange = (index, event) => {
    const { name, value } = event.target;
    const newInputs = [...inputs];
    newInputs[index][name] = value;
    setInputs(newInputs);
  };

  return (
    <div>
      {inputs.map((input, index) => (
        <div key={index} style={{ display: 'flex', marginBottom: '10px' }}>
          <input
            type="text"
            name="nome"
            value={input.nome}
            onChange={(e) => handleInputChange(index, e)}
            placeholder="Nome"
            style={{ marginRight: '10px' }}
          />
          <input
            type="text"
            name="valor"
            value={input.valor}
            onChange={(e) => handleInputChange(index, e)}
            placeholder="Valor"
          />
        </div>
      ))}
      <button onClick={addInputs}>+</button>
    </div>
  );
};

export default InputList;










uploadFile(file: File, pathParams: string[] = [], endpoint: string | null = null) {
  const formData = new FormData();
  formData.append('file', file);
  const config = {
    headers: {
      'Content-Type': 'multipart/form-data',
    },
  };
  const endpointBase = this.getEndpointWithPathParams(pathParams, endpoint);
  return axios.post(
    `${this.host.substr(0, this.host.indexOf('/api'))}/${endpointBase}/importExcel`,
    formData,
    config
  );
}
