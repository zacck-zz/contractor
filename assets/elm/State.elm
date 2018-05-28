module State exposing(..)

import Types exposing (Model, Msg(..), Page(..), SignUpInput, SignUpResponse)
import Utils exposing (validateSignUp)
import Navigation exposing (Location)
import UrlParser
import Route exposing (toPath)
import GraphQL.Request.Builder exposing (..)
import GraphQL.Request.Builder.Arg as Arg
import GraphQL.Request.Builder.Variable as Var



-- addUser Mutation
addUserMutation : SignUpInput -> Request Mutation SignUpResponse
addUserMutation signUpInput =
    let
        nameVar =
          Var.required "name" .name Var.string

        hashVar =
          Var.required "hash" .hash Var.string

        emailVar =
          Var.required "email" .email Var.string
     in
        extract
            (field "login"
              [ ("name", Arg.variable nameVar)
              , ("hash", Arg.variable hashVar)
              , ("email", Arg.variable emailVar)
              ]
              (object SignUpResponse
                    |> with (field "id" [] string)
              )
            )
            |> mutationDocument
            |> request
                { name =  signUpInput.name
                , email =  signUpInput.email
                , hash = signUpInput.hash
                }




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
     SubmitSignUp ->
       case validateSignUp model of
         [] ->
           ({ model  | errors = []}, Cmd.none)
         errors ->
           ({ model | errors = errors}, Cmd.none)
