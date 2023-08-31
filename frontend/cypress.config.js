const { defineConfig } = require('cypress')

module.exports = defineConfig({
  e2e: {
    baseUrl: 'http://127.0.0.1:3001',
    env: {
      apiUrl: 'http://127.0.0.1:3000'
    },
    video: false,
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
  },
})
