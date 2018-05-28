module Route exposing (..)

import UrlParser exposing (Parser, map, oneOf, top, s)

type Route
   = Home
   | Contracts
   | ContractDetails
   | SignIn
   | SignUp
   | AddContract
   | UpdateContract

route : Parser (Route -> Route) Route
route =
    oneOf
    [ map Home top
    , map Contracts (s "contracts")
    , map ContractDetails (s "details")
    , map SignIn (s "login")
    , map SignUp (s "signup")
    , map AddContract (s "add")
    , map UpdateContract (s "update")
    ]

toPath : Route -> String
toPath route =
    case route of
      Home ->
        "/"
      Contracts ->
        "/contracts"
      ContractDetails ->
        "/details"
      SignIn ->
        "/login"
      SignUp ->
        "/signup"
      AddContract ->
        "/add"
      UpdateContract ->
        "/update"
