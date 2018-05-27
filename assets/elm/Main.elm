module Main exposing (..)

import Html exposing (Html, div, text)
import Http
import Types exposing (Model, Msg(..))
import State exposing (peopleQuery, update)
import Utils exposing (authedGraphRequest)

main =
  Html.program
      { init = init
      , view = view
      , update = update
      , subscriptions = \_ -> Sub.none
      }


init : (Model, Cmd Msg)
init = { response = "Waiting For a response ... "} ! [
 Http.send FetchPeople (authedGraphRequest "" peopleQuery) ]

view : Model -> Html Msg
view model =
    div [] [ text model.response ]
