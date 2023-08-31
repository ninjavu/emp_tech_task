import { React, useState } from 'react'
import auth from 'api/auth.js'
import { useValidForm } from 'services/validation/validForm'
import validationSchema from 'services/validation/schemas/login.json'
import { Loader } from 'components/Loader'

export const Login = ({ setUser }) => {
  const [email, setEmail] = useState('')
  const validForm = useValidForm(validationSchema)
  const [validationErrors, setValidationErrors] = useState(validForm.initialState())
  const [isLoading, setIsLoading] = useState(false)

  const authenticate = () => {
    setValidationErrors(validForm.validateFields({ email }))
    if (validForm.isValid()) {
      setIsLoading(true)
      auth.authenticate(email)
        .then(data => {
          if (data.hasOwnProperty('errors')) {
            setValidationErrors({ email: data.errors })
          } else {
            localStorage.setItem('user', JSON.stringify({ email, ...data }))
            setUser({ email, ...data })
          }
          setIsLoading(false)
        })
    }
  }

  return (
    <>
      <h2>Login</h2>
      { isLoading ? <Loader/> : <>
        <span> enter Email</span>
        <input
          onChange = { e => setEmail(e.target.value) }
          value = { email } name='email' type='text'
          placeholder = 'email'
        />
        <div className='text-danger'>{ validationErrors.email[0] }</div>
        <button className='btn btn-outline-dark' onClick={ authenticate }>Sign In</button>
      </>
      }
    </>
  )
}

// describe('Login', () => {
//   it('should have email input', () => {
//     cy.visit('/')
//
//     cy.get('input[name=email]').should('have.value', '')
//   })
// })
