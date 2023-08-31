import 'bootstrap/dist/css/bootstrap.min.css'
import 'bootstrap/dist/js/bootstrap.bundle'
import { React, useState, useEffect } from 'react'
import { Routes, Route } from 'react-router-dom'
import { Home } from 'components/Home'
import { Index as MerchantIndex } from 'components/merchant/Index'
import { Update as MerchantUpdate } from 'components/merchant/Update'
import { Index as TransactionIndex } from 'components/transaction/Index'
import { Show as TransactionShow } from 'components/transaction/Show'
import { Show as MerchantShow } from 'components/merchant/Show'
import { ProtectedRoutes } from 'components/ProtectedRoutes'
import { Login } from 'components/Login'
import { Header } from 'components/Header'
import { Loader } from 'components/Loader'
import { USER_ROLES } from 'config/constants'

const App = () => {
  const [user, setUser] = useState(null)
  const [isLoading, setIsLoading] = useState(true)

  const getUserFromLS = () => {
    try {
      let user = JSON.parse(localStorage.getItem('user'))
      if (user.hasOwnProperty('role') && user.hasOwnProperty('token')) {
        return user
      }
    } catch (error) {
      localStorage.removeItem('user')
    }
  }

  useEffect(() => {
    let user = getUserFromLS()
    setUser(user)
    setIsLoading(false)
  }, [])

  return (
    <div className='App'>
      <div className='container'>
        { isLoading ? <Loader/> : <>
          {user ?
            <Header user={ user } setUser={ () => setUser(null) }/> :
            <Login setUser={ (user) => setUser(user) } />
          }
        </>
        }

        <Routes>
          <Route path = '/' element={ <Home user = { user } /> } />
          <Route path = '/merchant' element = { <ProtectedRoutes isAllowed = { user?.role === 'admin' } /> }>
            <Route path = 'index' element={ <MerchantIndex /> } />
            <Route path = 'update' element={ <MerchantUpdate /> } />
            <Route path = 'show' element={ <MerchantShow /> } />
          </Route>
          <Route path = '/transaction' element = { <ProtectedRoutes isAllowed = { USER_ROLES.includes(user?.role) } /> }>
            <Route path = 'index' element={ <TransactionIndex /> } />
            <Route path = 'show' element={ <TransactionShow /> } />
          </Route>
        </Routes>
      </div>
    </div>
  )
}

export default App
