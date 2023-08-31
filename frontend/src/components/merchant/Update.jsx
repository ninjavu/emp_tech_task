import { React, useState } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'
import merchantApi from 'api/merchant.js'
import { useValidForm } from 'services/validation/validForm'
import validationSchema from 'services/validation/schemas/merchant/update.json'
import { Loader } from 'components/Loader'

export const Update = () => {
  const STATUSES = ['active', 'inactive']
  const location = useLocation()
  const navigate = useNavigate()
  const validForm = useValidForm(validationSchema)
  const [validationErrors, setValidationErrors] = useState(validForm.initialState())
  const [isLoading, setIsLoading] = useState(false)

  const { merchant, user } = location.state

  const [description, setDescription] = useState(merchant.description)
  const [name, setName] = useState(merchant.name)
  const [status, setStatus] = useState(merchant.status)

  const updateMerchant = () => {
    setValidationErrors(validForm.validateFields({ name, description }))
    if (validForm.isValid()) {
      setIsLoading(true)
      let data = { name, description, status }
      merchantApi.update(merchant.id, data, user.token)
        .then(data => {
          if (data.hasOwnProperty('errors')) {
            setValidationErrors(data.errors)
          } else {
            alert('Merchant successfully updated')
            navigate('/merchant/index', { state: { user } })
          }
          setIsLoading(false)
        })
    }
  }

  return (
    <div>
      <h2>Merchant Update Page</h2>
      { isLoading ? <Loader/> : <>
        <form>
          <div className='form-group mb-2'>
            <span>Name: </span>
            <input
              onChange={ e => setName(e.target.value) }
              type='text'
              name='name'
              value={ name }
            />
            <span className='text-danger' id='name-error'>{ validationErrors?.name ? validationErrors?.name[0] : null }</span>
          </div>
          <div className='form-group mb-2'>
            <span>Description: </span>
            <input
              onChange={ e => setDescription(e.target.value) }
              type='text'
              name='description'
              value={ description }
            />
          </div>
          <div className='form-group'>
            <span>Status: </span>
            { STATUSES.map((option, i) => (
              <div key={i}>
                <input
                  type='radio'
                  value = { option }
                  id = { option }
                  name = { option }
                  onChange={ () => { setStatus(option) } }
                  checked={ option === status }
                />
                <label htmlFor = { option }>{ option }</label>
                <br/>
              </div>
            ))}
          </div>
        </form>
        <button className='btn btn-outline-secondary' onClick={ () => navigate(-1) }>Go back</button>
        <button className='btn btn-outline-success m-3' onClick={ updateMerchant }>Update Merchant</button>
      </>
      }
    </div>
  )
}
