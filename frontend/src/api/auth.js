import { backOffCall } from 'api/api.js'
import { API_URL } from 'config/constants'

const authenticate = (email) => {
  const query = () => {
    return fetch(`${API_URL}/authenticate`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        email: email,
      })
    })
  }

  return backOffCall(query)
}

export default {
  authenticate
}
