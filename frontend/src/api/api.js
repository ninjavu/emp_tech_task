import {
  BACKOFF_RECONNECTION_COUNT,
  BACKOFF_STATUS_CODES
} from 'config/constants'

const delay = (retryCount) => new Promise(resolve => setTimeout(resolve, (2 ** retryCount) * 100))

const backOffCall = async (query, retryCount = 0) => {
  await delay(retryCount)
  return query()
    .then((response) => {
      if (retryCount >= BACKOFF_RECONNECTION_COUNT) {
        throw new Error('time out error')
      }

      if (response.status === 401) {
        alert('auth wrong')
        localStorage.removeItem('user')
        window.location.reload()
      }

      if (response.status === 500) {
        throw new Error('server is down')
      }

      if (BACKOFF_STATUS_CODES.includes(response.status)) {
        return backOffCall(query, retryCount + 1)
      }

      if (response.headers.get('content-type') === 'text/html') {
        return response.text()
      }

      return response.json()
    }).catch(error => {
      alert('Server error')
      return false
    })
}

export {
  backOffCall
}
