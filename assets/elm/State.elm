module State exposing(..)

import Types exposing (Model, Msg(..), Page(..), SignUpInput, Registration, RegistrationResponse, Person, SignUpDetails, PeopleResponse, LoginInput, LoginDetails,Session)
import Utils exposing (validateSignUp, validateSignIn, sendAuthedMutation, sendAuthedQuery)
import Navigation exposing (Location)
import UrlParser
import Route exposing (toPath)
import GraphQL.Request.Builder exposing (..)
import GraphQL.Request.Builder.Arg as Arg
import GraphQL.Request.Builder.Variable as Var
import Task exposing (Task)



-- addUser Mutation
addUserMutation : SignUpInput -> Request Mutation Registration
addUserMutation signUpInput =
    let
        inputVar =
          Var.required "input"
              .input
              (Var.object "AddUserInput"
                  [ Var.field "name" .name Var.string
                  , Var.field "email" .email Var.string
                  , Var.field "hash" .hash Var.string
                  ]
              )
     in
        extract
            (field "addUser"
              [ ("input", Arg.variable inputVar) ]
              (object Registration
                    |> with (field "id" [] string)
              )
            )
            |> mutationDocument
            |> request
                { input =  signUpInput.input }


-- login Mutation
loginMutation : LoginInput -> Request Mutation Session
loginMutation loginInput =
    let
        inputVar =
          Var.required "input"
              .input
              (Var.object "LoginInput"
                  [ Var.field "password" .password Var.string
                  , Var.field "email" .email Var.string
                  ]
              )
    in
      extract
        (field "login"
          [("input", Arg.variable inputVar)]
          (object Session
                |> with (field "token" [] string)
          )
        )
        |> mutationDocument
        |> request
              { input = loginInput.input }




peopleQuery : Request Query (List Person)
peopleQuery =
    extract
      (field "people"
        []
        (list
            (object Person
                |> with (field "id" [] string)
                |> with (field "name" [] string)
                |> with (field "email" [] string)
            )
        )
      )
      |> queryDocument
      |> request
            {}



-- login reques dispatch
sendSignInRequest : LoginInput -> Model -> Cmd Msg
sendSignInRequest loginInput model =
    sendAuthedMutation model (loginMutation loginInput)
      |> Task.attempt ReceiveSessionResponse


-- signup request
sendSignUpRequest : SignUpInput -> Model -> Cmd Msg
sendSignUpRequest signUpInput model =
    sendAuthedMutation model (addUserMutation signUpInput)
          |> Task.attempt ReceiveRegistrationResponse


-- people request
sendPeopleRequest : Model -> Cmd Msg
sendPeopleRequest model =
    sendAuthedQuery model peopleQuery
      |> Task.attempt ReceivePeopleResponse





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
           (model, (sendSignUpRequest { input = (SignUpDetails model.name model.email model.password)} model))
         errors ->
           ({ model | errors = errors}, Cmd.none)
     GetPeople ->
       (model, (sendPeopleRequest model))
     ReceiveRegistrationResponse response ->
       case response of
         Ok result ->
           ({ model | registration = Just result}, (Navigation.newUrl <| toPath Route.SignIn))

         Err err ->
           ({ model | errors = [ toString err ]}, Cmd.none)
     ReceivePeopleResponse response ->
       let
           people =
             case response of
               Ok result ->
                 result

               Err err ->
                 []
       in
          ({ model | people = people}
          , Cmd.none)

     SubmitSignIn ->
      case validateSignIn model of
        [] ->
          (model, (sendSignInRequest { input = (LoginDetails model.email model.password)} model))
        errors ->
          ({ model | errors = errors}, Cmd.none)

     ReceiveSessionResponse response ->
      case response of
        Ok result ->
          ( { model | token = result.token }, (Navigation.newUrl <| toPath Route.Contracts))

        Err err ->
          ({ model | errors = [toString err] }, Cmd.none)
