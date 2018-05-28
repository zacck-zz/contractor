module State exposing(..)


import Http 
import Json.Encode as Encode 
import Json.Decode as Decode 
import Types exposing (Model, Msg(..), Page(..))
import Utils exposing (graphUrl, queryBody, authedGraphRequest)
import Navigation exposing (Location)
import UrlParser
import Route

-- Draw up a people query
peopleQuery : String
peopleQuery =
    """
    {
      people {
        id
        name
      }
    }
    """

-- parsePath reads the path in the url and turns it into a new type
setRoute : Location -> Model -> Model 
setRoute location model =
    let
       route = 
        UrlParser.parsePath Route.route location
           |> Maybe.withDefault Route.Home
    in   
        case route of 
            Route.Home ->
                { model | page = Home }
            Route.Contracts ->
                { model | page = Contracts }
            Route.ContractDetails ->
                { model | page = ContractDetails }
            Route.SignIn ->
                { model | page = SignIn }
            Route.SignUp ->
                { model | page = SignUp }
            Route.AddContract ->
                { model | page = AddContract }
            Route.UpdateContract -> 
                { model | page = UpdateContract } 

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
   case msg of
     FetchPeople response ->
       case response of
         Ok result ->
             ({ model | response = result }, Cmd.none)

         Err err ->
           ({ model | response = toString err }, Cmd.none)
     SetRoute location -> 
         ( setRoute location model, Cmd.none )




