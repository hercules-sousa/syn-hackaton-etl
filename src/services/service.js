import api from '../services/api'

const ENDPOINT_BASE = 'teste'

export function getDados() {
  api.get(ENDPOINT_BASE)
      .then((response) => console.log(response))
      .catch((err) => {
        console.error("ops! ocorreu um erro" + err);
     });
}

export async function postDados(data) {
  const response = await api.post(ENDPOINT_BASE, data);
}

export async function postDados2(data) {
  try {
    const response = await axios.post(ENDPOINT_BASE, data, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    });
    console.log('Resposta do servidor:', response.data);
  } catch (error) {
    console.error('Erro ao enviar o XML:', error);
  }
}

export function deleteDados(id) {
  api.delete(ENDPOINT_BASE, { id });
}

export async function updateDados(data) {
  const personUpdated = await api.put(ENDPOINT_BASE, data);
}