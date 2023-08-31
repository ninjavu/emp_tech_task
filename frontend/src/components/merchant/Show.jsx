import { React, useState } from 'react'
import { Link, useLocation, useNavigate } from 'react-router-dom'
import merchantApi from 'api/merchant'
import { Loader } from 'components/Loader'

export const Show = () => {
  const location = useLocation()
  const navigate = useNavigate()
  const { merchant, user } = location.state
  const [isLoading, setIsLoading] = useState(false)

  const deleteMerchant = () => {
    setIsLoading(true)
    merchantApi.destroy(merchant.id, user.token)
      .then(data => {
        if (data.hasOwnProperty('errors')) {
          alert(`Deleting Failed!!! ${data.errors.server}`)
        } else {
          alert('Merchant successfully deleted')
          navigate(-1)
        }
        setIsLoading(false)
      })
  }

  return (
    <>
      <h2>Merchant Info Page</h2>
      { isLoading ? <Loader/> : <>
        <table className="table">
          <thead>
            <tr>
              <th scope="col">Id</th>
              <th scope="col">Status</th>
              <th scope="col">Name</th>
              <th scope="col">Description</th>
              <th scope="col">Email</th>
              <th scope="col">Created at</th>
            </tr>
          </thead>
          <tbody>
            <tr key={ merchant.id }>
              <td>{ merchant.id }</td>
              <td>{ merchant.status }</td>
              <td>{ merchant.name }</td>
              <td>{ merchant.description }</td>
              <td>{ merchant.email }</td>
              <td>{ merchant.created_at }</td>
            </tr>
          </tbody>
        </table>

        <button className='btn btn-outline-secondary' onClick={ () => navigate(-1) }>Go back</button>
        <Link
          to="/merchant/update"
          state={{ merchant, user }}
          className='btn btn-outline-success m-3'>
          Update Merchant
        </Link>
        <button className='btn btn-outline-danger' onClick={ deleteMerchant }>Delete Merchant</button>
      </>
      }
    </>
  )
}
