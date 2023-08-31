
export const useValidForm = (schema) => {
  const validationRules = {
    isEmpty: {
      rule: (value) => {
        return !value
      },
      message: () => {
        return 'is empty'
      }
    },

    minLength: {
      rule: (value, ruleAttribute) => {
        return value?.length < ruleAttribute
      },
      message: (_, ruleAttribute) => {
        return `must be at least ${ruleAttribute} symbols`
      }
    },

    maxLength: {
      rule: (value, ruleAttribute) => {
        return value?.length > ruleAttribute
      },
      message: (_, ruleAttribute) => {
        return `must be less than ${ruleAttribute} symbols`
      }
    },

    isEmail: {
      rule: (value) => {
        const regex = /[^\s@]+@[^\s@]+\.[^\s@]+/gi
        return !regex.test(value)
      },
      message: () => {
        return 'email wrong format'
      }
    }
  }

  let currentErrorsState = null

  const validateField = (field, value) => {
    let fieldErrors = []
    for (const validation in schema[field]) {
      if (schema[field][validation] && validationRules[validation].rule(value, schema[field][validation])) {
        fieldErrors.push(validationRules[validation].message(value, schema[field][validation]))
      }
    }
    return fieldErrors
  }

  const validateFields = (fields) => {
    let errors = {}
    for (const field in fields) {
      errors[field] = validateField(field, fields[field])
    }
    currentErrorsState = errors
    return errors
  }

  const initialState = () => {
    let arr = {}
    for (const field in schema) {
      arr[field] = []
    }

    return arr
  }

  const isValid = () => {
    for (const field in currentErrorsState) {
      if (currentErrorsState[field].length !== 0) {
        return false
      }
    }

    return true
  }

  return { validateFields, initialState, isValid }
}
