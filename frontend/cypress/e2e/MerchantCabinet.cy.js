describe('Home', { testIsolation: false }, () => {
  before(() => {
    cy.fixture('merchantUser').then((user) => {
      window.localStorage.setItem('user', JSON.stringify(user.user))
    })
  })

  it('should be merchant cabinet', () => {
    cy.log(window.localStorage.getItem('user'))
    cy.visit('/')
    cy.get('span[id=cabinet]').should('have.text', 'merchant cabinet')
  })

  it('should have transactions tab', () => {
    cy.log(window.localStorage.getItem('user'))
    cy.visit('/')
    cy.get('a').contains('Transactions').should('exist')
  })

  describe('Transactions', { testIsolation: false }, () => {
    before(() => {
      cy.fixture('transactions').then((transactions) => {
        cy.intercept('GET', `${Cypress.env('apiUrl')}/transactions`, {
          statusCode: 200,
          body: transactions
        })
      })
    })

    it('should render transactions', () => {
      cy.get('a').contains('Transactions').click()
      cy.get('table[id=transactions-table').should('exist')
    })

    it('should redirect to Transactions Index page', () => {
      cy.get('h2').contains('Transactions Index').should('exist')
    })

    it('should redirect to Transaction Show page', () => {
      cy.get('table tr a').first().click()
      cy.get('h2').contains('Transaction info').should('exist')
    })

    it('should display Transaction Info', () => {
      cy.get('table td').first().contains('e14a0a1d-ce38-4881-a94e-5b3fe37d6f87')
    })

    it('should redirect back by click', () => {
      cy.get('button').contains('Go back').click()
      cy.get('h2').contains('Transactions Index').should('exist')
    })
  })

  describe('Log out process', { testIsolation: false }, () => {
    before(() => {
      cy.intercept('GET', `${Cypress.env('apiUrl')}/transactions`, {
        statusCode: 200,
        body: { transactions: [] }
      })
    })
    it('should redirect to Login page', () => {
      cy.get('button').contains('Log out').click()
      cy.get('h2').contains('Login').should('exist')
    })

    it('should delete user from LS', () => {
      assert.equal(window.localStorage.getItem('user'), null)
    })
  })
})
