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
  2. Set up your git local githooks copy the files in the `/hooks` folder into the `.git` folder
		`cd /hooks && cp * ../.git/hooks`
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



# Application Flow

## Screens

### landing page
![initial_page](https://user-images.githubusercontent.com/897731/40707534-3d23d31e-63f1-11e8-91fc-a28cff0909a7.png)

### sign up
![sign_up_page](https://user-images.githubusercontent.com/897731/40707533-3cf772a6-63f1-11e8-9bdb-6a2beaf115ff.png)

### login
![login_page](https://user-images.githubusercontent.com/897731/40707532-3cc615b2-63f1-11e8-805d-e1150874f559.png)

### contracts
![contracts_page](https://user-images.githubusercontent.com/897731/40707531-3c99babc-63f1-11e8-8bb1-89c17516c596.png)

### contract details
![contract_details](https://user-images.githubusercontent.com/897731/40707529-3c3e6acc-63f1-11e8-8cae-743e369715ed.png)

### add contract
![add_contract](https://user-images.githubusercontent.com/897731/40707530-3c68cd8a-63f1-11e8-89c7-8c3453ee4c71.png)



# Authors

  *  **Zacck Osiemo** - *Initial Work* - [Zacck](https://github.com/zacck)
