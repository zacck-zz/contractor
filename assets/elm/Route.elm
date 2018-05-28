module Route exposing(Route(..), route)

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
