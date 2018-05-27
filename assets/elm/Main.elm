module Main exposing (..)

import Html exposing(Html)
import Http
import Types exposing (Model, Msg(..))
import State exposing (peopleQuery, update)
import Utils exposing (authedGraphRequest)
import View exposing (view)

main =
  Html.program
      { init = init
      , view = view
      , update = update
      , subscriptions = \_ -> Sub.none
      }


initialModel : Model 
initialModel =
    { response = "Waiting for a response ..."
    , token =""
    }

init : (Model, Cmd Msg)
init = initialModel ! [
 Http.send FetchPeople (authedGraphRequest "" peopleQuery) ]


