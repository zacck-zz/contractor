module State exposing(..)


import Http
import Json.Encode as Encode
import Json.Decode as Decode
import Types exposing (Model, Msg(..), Page(..))
import Utils exposing (graphUrl, queryBody, authedGraphRequest)
import Navigation exposing (Location)
import UrlParser
import Route exposing (toPath)

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
setRoute : Location -> Model -> (Model, Cmd Msg)
setRoute location model =
    let
       route =
        UrlParser.parsePath Route.route location
           |> Maybe.withDefault Route.Home
    in
        case route of
            Route.Home ->
                ({ model | page = Home }, Cmd.none)
            Route.Contracts ->
                ({ model | page = Contracts }, Cmd.none)
            Route.ContractDetails ->
                ({ model | page = ContractDetails }, Cmd.none)
            Route.SignIn ->
                ({ model | page = SignIn }, Cmd.none)
            Route.SignUp ->
                ({ model | page = SignUp }, Cmd.none)
            Route.AddContract ->
                ({ model | page = AddContract }, Cmd.none)
            Route.UpdateContract ->
                ({ model | page = UpdateContract }, Cmd.none)


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
         ( setRoute location model)

     NavigateTo route ->
       (model , (Navigation.newUrl <| toPath route))
     SetEmail email ->
       ({ model | email = email}, Cmd.none)
     SetPassword password ->
       ({ model | password = password }, Cmd.none)
     SetPasswordConf passwordconf ->
       ({ model | passwordconf = passwordconf}, Cmd.none)
     SetName name ->
       ({ model | name = name }, Cmd.none)
