import { React } from 'react'

export const Home = ({ user }) => {
  return (
    <>
      { user ? (
        <>
          <h2>User Info</h2>
          <div>
            <span className='fw-bold'>Email: </span>
            <span>{ user?.email }</span>
          </div>

          <div>
            <span className='fw-bold'>Role: </span>
            <span>{ user?.role }</span>
          </div>
        </>
      ) : null }
    </>
  )
}
