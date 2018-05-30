# Contractor

Contractor is an application that helps you manage your Contracts. You can use Contractor to store
details about your contracts and update them as times go by.


## Getting Started
Contractor is built using the Phoenix framework. We use [Elixir](https://elixir-lang.org/) to build our backend logic for the system and the User Interface is built in [Elm](http://elm-lang.org/G) they communicate over a [GraphQL](https://hexdocs.pm/absinthe/overview.html) end point.

### Prerequisites

- Basic Understanding of Elm
- Basic Understanding of Phoenix
- Good Knowledge of Elixir/OTP applications


### Getting Up and Running
  1. Clone this repository using the following command
      `git clone git@github.com:zacck/contractor.git`
  2. Install mix dependecies using the following command (run this in the project folder)
      `mix deps.get`
  3. Seed the database with some default data using the following command
      `mix ecto.setup`
  4. Install elm dependecies using the following command (run this in the assets directory)
      `elm-package install`
  5. Run tests using the following command
      `MIX_ENV=test mix test`
  6. Start the application using
      `mix phx.server`
  7. Visit the running application on
      [localhost](http://localhost:4000)



# Authors

  *  **Zacck Osiemo** - *Initial Work* - [Zacck](https://github.com/zacck)
