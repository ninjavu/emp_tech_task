describe('Login', { testIsolation: false }, () => {
  before(() => {
    localStorage.clear()
  })

  it('should have empty email input', () => {
    cy.visit('/')
    cy.get('input[name=email]').should('have.value', '')
  })

  it('should contains entered value', () => {
    cy.get('input[name=email]').type('test').should('have.value', 'test')
  })

  it('should validate email', () => {
    cy.contains('Sign In').click()
    cy.get('div[class=text-danger]').should('have.text', 'email wrong format')
  })
})

describe('Success auth', { testIsolation: false }, () => {
  let userData = {
    email: 'test@test.com',
    token: '123123123',
    role: 'admin',
  }

  beforeEach(() => {
    cy.intercept('POST', `${Cypress.env('apiUrl')}/authenticate`, {
      statusCode: 200,
      body: userData
    })
  })

  it('does not display error', () => {
    cy.visit('/')
    cy.get('input[name=email]').clear().type('test@test.com')
    cy.contains('Sign In').click()
    cy.get('div[class=text-danger]').should('not.exist')
  })

  it('writes user to LS', () => {
    cy.wait(1500)
    cy.window().then((window) => {
      assert.equal(window.localStorage.getItem('user'), JSON.stringify(userData))
    })
  })
})

describe('Failed auth', () => {
  before(() => {
    cy.intercept('POST', `${Cypress.env('apiUrl')}/authenticate`, {
      statusCode: 400,
      body: {
        errors: ['user does not exist']
      },
    })
    localStorage.clear()
  })

  it('displays error', () => {
    cy.visit('/')
    cy.get('input[name=email]').clear().type('test@test.com')
    cy.contains('Sign In').click()
    cy.get('div[class=text-danger]').should('have.text', 'user does not exist')
  })
})
