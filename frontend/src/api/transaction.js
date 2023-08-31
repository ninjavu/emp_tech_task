import { backOffCall } from 'api/api.js'
import { API_URL } from 'config/constants'

const index = (token) => {
  const query = () => {
    return fetch(`${API_URL}/transactions`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token
      }
    })
  }

  return backOffCall(query)
}

export default {
  index
}
