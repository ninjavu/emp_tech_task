import { backOffCall } from 'api/api.js'
import { API_URL } from 'config/constants'

const index = (token) => {
  const query = () => {
    return fetch(`${API_URL}/merchants`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token
      }
    })
  }

  return backOffCall(query)
}

const update = (id, data, token) => {
  const query = () => {
    return fetch(`${API_URL}/merchants/${id}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token
      },
      body: JSON.stringify({
        ...data
      })
    })
  }

  return backOffCall(query)
}

const destroy = (id, token) => {
  const query = () => {
    return fetch(`${API_URL}/merchants/${id}`, {
      method: 'DELETE',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token
      }
    })
  }

  return backOffCall(query)
}

export default {
  index,
  update,
  destroy
}
