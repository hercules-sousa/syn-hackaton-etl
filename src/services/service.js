import api from '../services/api'

const ENDPOINT_BASE = 'transformaXml'

export function getDados() {
  api.get(ENDPOINT_BASE)
      .then((response) => console.log(response))
      .catch((err) => {
        console.error("ops! ocorreu um erro" + err);
     });
}

export async function postDados(data) {
  try {
    const response = await api.post(ENDPOINT_BASE, data, {
      headers: {
        'Content-Type': 'application/json',
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