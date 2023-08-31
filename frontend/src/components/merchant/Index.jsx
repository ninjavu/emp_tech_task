import { React, useState, useEffect } from 'react'
import merchantApi from 'api/merchant.js'
import { Loader } from 'components/Loader'
import { Link } from 'react-router-dom'
import { useLocation } from 'react-router-dom'

export const Index = () => {
  const location = useLocation()
  const { user } = location.state

  const [isLoading, setIsLoading] = useState(false)
  const [merchants, setMerchants] = useState([])

  useEffect(() => {
    setIsLoading(true)
    merchantApi.index(user.token)
      .then(data => {
        setMerchants(data.merchants)
        setIsLoading(false)
      })
  }, [])

  return (
    <>
      <h2>Merchants Index Page</h2>
      { isLoading ? <Loader/> : <table className="table" id='merchants-table'>
        <thead>
          <tr>
            <th scope="col">#</th>
            <th scope="col">Id</th>
            <th scope="col">Name</th>
            <th scope="col">Email</th>
            <th scope="col">Status</th>
          </tr>
        </thead>
        <tbody>
          { merchants.map((merchant, i) => (
            <tr key={ merchant.id }>
              <th>{ i + 1 }</th>
              <td>
                <Link to="/merchant/show" state={{ merchant, user }}>
                  {merchant.id}
                </Link>
              </td>
              <td>{merchant.name}</td>
              <td>{merchant.email}</td>
              <td>{merchant.status}</td>
            </tr>
          ))}
        </tbody>
      </table>
      }
    </>
  )
}
