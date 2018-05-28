module Utils exposing (..)


import Json.Encode as Encode
import Json.Decode as Decode exposing(Decoder)
import Json.Decode.Pipeline as Pipeline
import Http
import Types exposing(Person)
import Validate exposing (Validator, ifBlank, ifInvalidEmail, validate)
import Types exposing(Model)


-- validates a model for signups
signUpValidator : Validator String Model
signUpValidator =
    Validate.all
      [ ifBlank .name  "Please enter a name"
      , Validate.firstError
          [ ifBlank .email "Please enter an email address"
          , ifInvalidEmail .email (\_ -> "Please enter a valid email address")
          ]
      , ifBlank .password "Please enter a password"
      , ifBlank .passwordconf "Please enter a Password Confirmation"
      ]

validateSignUp : Model -> List String
validateSignUp model =
    validate signUpValidator model

-- Url for the graphql endpoint
graphUrl : String
graphUrl =
    "http://localhost:4000/api/graph"

-- Encode query object
queryEncoder : String -> Encode.Value
queryEncoder query =
    Encode.object
      [("query", Encode.string query)]


-- Creates a jsonBody of a query
queryBody : String -> Http.Body
queryBody data =
  let
    body =
      data
        |> queryEncoder
        |> Http.jsonBody
   in
    body



-- Decoder for person graph
personDecoder : Decoder Person
personDecoder =
    Pipeline.decode Person
        |> Pipeline.required "id" Decode.string
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "email" Decode.string




-- build authenticated graphRequest
authedGraphRequest : String  -> String -> Http.Request String
authedGraphRequest  token body =
  { method = "POST"
  , headers = [ Http.header "Authorization" ("Bearer " ++ token)]
  , url = graphUrl
  , body = body |> queryBody
  , expect =  Http.expectString
  , timeout = Nothing
  , withCredentials = False
  }
    |> Http.request
