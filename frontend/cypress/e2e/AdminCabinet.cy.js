describe('Home', { testIsolation: false }, () => {
  before(() => {
    cy.fixture('adminUser').then((user) => {
      window.localStorage.setItem('user', JSON.stringify(user.user))
    })
  })

  it('should be an admin cabinet', () => {
    cy.visit('/')
    cy.get('span[id=cabinet]').should('have.text', 'admin cabinet')
  })

  it('should have merchants tab', () => {
    cy.visit('/')
    cy.get('a').contains('Merchants').should('exist')
  })

  describe('Merchants', { testIsolation: false }, () => {
    beforeEach(() => {
      cy.fixture('merchants').then((merchants) => {
        cy.intercept('GET', `${Cypress.env('apiUrl')}/merchants`, {
          statusCode: 200,
          body: merchants
        })
      })
    })

    it('should render merchants', () => {
      cy.get('a').contains('Merchants').click()
      cy.get('table[id=merchants-table').should('exist')
    })

    it('should redirect to Merchants Index page', () => {
      cy.get('h2').contains('Merchants Index Page').should('exist')
    })

    it('should redirect to Merchants Show page', () => {
      cy.get('table tr a').first().click()
      cy.get('h2').contains('Merchant Info Page').should('exist')
    })

    it('should display Merchants Info', () => {
      cy.get('table td').first().contains('2')
    })

    it('should redirect to Merchants Update page', () => {
      cy.get('a').contains('Update Merchant').click()
      cy.get('h2').contains('Merchant Update Page').should('exist')
    })

    describe('Failed Merchants Update', { testIsolation: false }, () => {
      beforeEach(() => {
        cy.intercept('PATCH', `${Cypress.env('apiUrl')}/merchants/**`, {
          statusCode: 400,
          body: {
            errors: { name: ['name already exist'] }
          },
        })
      })

      it('should contains entered values', () => {
        cy.get('input[name=name]').clear().type('t').should('have.value', 't')
      })

      it('should display validation errors', () => {
        cy.get('button').contains('Update Merchant').click()
        cy.get('span[id=name-update-error]').should('have.text', 'must be at least 3 symbols')
      })

      it('should display server errors', () => {
        cy.get('input[name=name]').clear().type('test')
        cy.get('button').contains('Update Merchant').click()
        cy.get('span[id=name-update-error]').should('have.text', 'name already exist')
      })
    })

    describe('Success Merchants Update', { testIsolation: false }, () => {
      beforeEach(() => {
        cy.intercept('PATCH', `${Cypress.env('apiUrl')}/merchants/**`, {
          statusCode: 200
        })
      })

      it('should contains entered values', () => {
        cy.get('input[name=name]').clear().type('nameTest').should('have.value', 'nameTest')
        cy.get('input[name=description]').clear().type('descriptionTest').should('have.value', 'descriptionTest')
      })

      it('should update merchant', () => {
        cy.get('button').contains('Update Merchant').click()
        cy.on('window:alert', (str) => {
          expect(str).to.equal('Merchant successfully updated')
        })
      })

      it('should redirect to index page', () => {
        cy.get('h2').contains('Merchants Index Page').should('exist')
      })
    })

    describe('Failed Merchants Deletion', { testIsolation: false }, () => {
      beforeEach(() => {
        cy.intercept('DELETE', `${Cypress.env('apiUrl')}/merchants/**`, {
          statusCode: 400,
          body: {
            errors: { server: 'Transactions exist' }
          },
        })
      })

      it('should display error when transactions exist', () => {
        cy.get('table tr a').first().click()
        cy.get('button').contains('Delete Merchant').click()
        cy.on('window:alert', (str) => {
          expect(str).to.equal('Deleting Failed!!! Transactions exist')
        })
      })

      it('should remains on show page', () => {
        cy.get('h2').contains('Merchant Info Page').should('exist')
      })
    })

    describe('Success Merchants Deletion', { testIsolation: false }, () => {
      beforeEach(() => {
        cy.intercept('DELETE', `${Cypress.env('apiUrl')}/merchants/**`, {
          statusCode: 200
        })
      })

      it('should display success alert', () => {
        cy.get('button').contains('Delete Merchant').click()
        cy.on('window:alert', (str) => {
          expect(str).to.equal('Merchant successfully deleted')
        })
      })

      it('should redirect to index page', () => {
        cy.get('h2').contains('Merchants Index Page').should('exist')
      })
    })
  })

  describe('Log out process', { testIsolation: false }, () => {
    it('should redirect to Login page', () => {
      cy.get('button').contains('Log out').click()
      cy.get('h2').contains('Login').should('exist')
    })

    it('should delete admin user from LS', () => {
      assert.equal(window.localStorage.getItem('user'), null)
    })
  })
})
