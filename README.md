Welcome, it's emp task

![app component's diagram](https://github.com/ninjavu/emp_tech_task/blob/develop/diagram.png)


Application is fully dockerized, for launch please:

1. cp .env.sample .env
2. cp frontend/.env.sample frontend/.env
3. docker-compose up
4. open localhost:3001

app components
  backend
    controllers (http layer)
    models (data layer)
    interactors (business logic)
    services (syncronous task)
    jobs (async task)
    contracts (process parameters)
    rspec (all changes)

  frontend
    components
    cypress
