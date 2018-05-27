module Main exposing (..)

import Html exposing (Html, div, text)
import Http
import Json.Encode as Encode
import Json.Decode as Decode exposing (..)


main =
  Html.program
      { init = init
      , view = view
      , update = update
      , subscriptions = \_ -> Sub.none
      }


type alias Model =
  { response : String
  }


type Msg
    = FetchPeople (Result Http.Error String)


graphUrl : String
graphUrl =
    "http://localhost:4000/api/graph"


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

-- Encode query object
queryEncoder : String -> Encode.Value
queryEncoder query =
    Encode.object
      [("query", Encode.string query)]


-- Decode Http String Result
resultDecoder : Decoder String
resultDecoder =
    Decode.field "data" Decode.string

-- build a Request with our query
graphRequest : String -> String -> Http.Request String
graphRequest url data =
  let
    body =
        data
          |> queryEncoder
          |> Http.jsonBody
          |> Debug.log("data")


  in
      Http.post url body resultDecoder




init : (Model, Cmd Msg)
init = { response = "Waiting For a response ... "} ! [
 Http.send FetchPeople (graphRequest graphUrl peopleQuery) ]



update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
   case msg of
     FetchPeople response ->
       case response of
         Ok result ->
           { response = result } ! []

         Err err ->
           { response = toString err } ! []

view : Model -> Html Msg
view model =
    div [] [ text model.response ]
