import { React } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'

export const Show = () => {
  const location = useLocation()
  const navigate = useNavigate()
  const { transaction } = location.state

  return (
    <>
      <h2> Transaction info</h2>
      <table className="table">
        <thead>
          <tr>
            <th scope="col">Id</th>
            <th scope="col">Amount</th>
            <th scope="col">Status</th>
            <th scope="col">Customer email</th>
            <th scope="col">Customer phone</th>
            <th scope="col">Created at</th>
          </tr>
        </thead>
        <tbody>
          <tr key={ transaction.id }>
            <td>{ transaction.id }</td>
            <td>{ transaction.amount }</td>
            <td>{ transaction.status }</td>
            <td>{ transaction.customer_email }</td>
            <td>{ transaction.customer_phone }</td>
            <td>{ transaction.created_at }</td>
          </tr>
        </tbody>
      </table>
      <button className='btn btn-outline-secondary' onClick={() => navigate(-1)}>Go back</button>
    </>
  )
}
