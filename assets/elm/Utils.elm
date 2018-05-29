module Utils exposing (..)

import Types exposing(Person, Model,  Msg(..), LoadedVendor)
import Validate exposing (Validator, ifBlank, ifInvalidEmail, ifFalse, ifTrue, validate)
import GraphQL.Client.Http as GraphQLClient
import GraphQL.Request.Builder exposing (..)
import Http
import Task exposing(Task)
import Select

-- query if the string is long enpough
transformQuery : String -> Maybe String
transformQuery query =
    if String.length query < 2 then
      Nothing
    else
      Just query


-- configure select box
selectConfig : Select.Config Msg LoadedVendor
selectConfig =
    Select.newConfig OnVendorSelect .name
      |> Select.withCutoff 5
      |> Select.withMenuClass "border border-gray"
      |> Select.withMenuStyles [ ( "background", "white" ) ]
      |> Select.withNotFound "No matches"
      |> Select.withNotFoundClass "red"
      |> Select.withNotFoundStyles [ ( "padding", "0 2rem" ) ]
      |> Select.withHighlightedItemClass "bg-silver"
      |> Select.withHighlightedItemStyles [ ( "color", "black" ) ]
      |> Select.withPrompt "Search for a Vendor .."
      |> Select.withPromptClass "grey"
      |> Select.withUnderlineClass "underline"
      |> Select.withTransformQuery transformQuery



-- validates a model for signups
signUpValidator : Validator String Model
signUpValidator =
    Validate.all
      [ ifBlank .name  "Please enter a name"
      , Validate.firstError
          [ ifBlank .email "Please enter an email address"
          , ifInvalidEmail .email (\_ -> "Please enter a valid email address")
          ]
      , Validate.firstError
          [ ifTrue (\model -> String.length model.password < 8) "Password need to be atleast 8 characters"
          , ifBlank .password "Please enter a password"
          ]
      , ifBlank .passwordconf "Please enter a Password Confirmation"
      , ifFalse (\model -> model.password == model.passwordconf) "Password must match Password Confirmation"
      ]

-- validates a model for signins
signInValidator : Validator String Model
signInValidator =
  Validate.all
    [ Validate.firstError
        [ ifBlank .email "Please enter an email address"
        , ifInvalidEmail .email (\_ -> "Please enter a valid email address")
        ]
    , Validate.firstError
        [ ifTrue (\model -> String.length model.password < 8) "Password need to be atleast 8 characters"
        , ifBlank .password "Please enter a password"
        ]
    ]


-- authvalidator : Validator String Model
authvalidator : Validator String Model
authvalidator =
    Validate.all
      [ ifBlank .token "Please Login to View Contracts"]


--validateAuth : Model -> List String
validateAuth : Model -> List String
validateAuth model =
    validate authvalidator model


validateSignIn : Model -> List String
validateSignIn model =
    validate signInValidator model

validateSignUp : Model -> List String
validateSignUp model =
    validate signUpValidator model

-- Url for the graphql endpoint
graphUrl : String
graphUrl =
    "http://localhost:4000/api/graph"

-- create custom request graphql request options
authedGraphRequest : Model -> GraphQLClient.RequestOptions
authedGraphRequest model =
  let
    headers = [Http.header "Authorization" ("Bearer " ++ model.token)]
  in
    { method = "Post", headers = headers, url = graphUrl, timeout = Just 1000, withCredentials = False }


sendAuthedQuery : Model -> Request Query a -> Task GraphQLClient.Error a
sendAuthedQuery model aQueryRequest =
    GraphQLClient.customSendQuery (authedGraphRequest model) aQueryRequest

sendAuthedMutation : Model -> Request Mutation a -> Task GraphQLClient.Error a
sendAuthedMutation model aMutationRequest =
    GraphQLClient.customSendMutation (authedGraphRequest model) aMutationRequest
