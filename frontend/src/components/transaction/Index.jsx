import { React, useState, useEffect } from 'react'
import transactionApi from 'api/transaction.js'
import { Loader } from 'components/Loader'
import { Link } from 'react-router-dom'
import { useLocation } from 'react-router-dom'

export const Index = () => {
  const location = useLocation()
  const { user } = location.state

  const [isLoading, setIsLoading] = useState(false)
  const [transactions, setTransactions] = useState([])

  useEffect(() => {
    setIsLoading(true)
    transactionApi.index(user.token)
      .then(data => {
        setTransactions(data.transactions)
        setIsLoading(false)
      })
  }, [])

  return (
    <>
      <h2> Transactions Index </h2>
      { isLoading ? <Loader/> : <table className="table" id='transactions-table'>
        <thead>
          <tr>
            <th scope="col">#</th>
            <th scope="col">Id</th>
            <th scope="col">Amount</th>
            <th scope="col">Status</th>
          </tr>
        </thead>
        <tbody>
          { transactions.map((transaction, i) => (
            <tr key={ transaction.id }>
              <th>{ i + 1 }</th>
              <td>
                <Link to="/transaction/show" state={{ transaction }}>
                  { transaction.id }
                </Link>
              </td>
              <td>{ transaction.amount }</td>
              <td>{ transaction.status }</td>
            </tr>
          ))}
        </tbody>
      </table>
      }
    </>
  )
}
