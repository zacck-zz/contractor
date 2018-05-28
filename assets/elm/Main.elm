module Main exposing (..)

import Html exposing(Html)
import Http
import Types exposing (Model, Msg(..), Page(..))
import State exposing (peopleQuery, update, setRoute)
import Utils exposing (authedGraphRequest)
import View exposing (view)
import Navigation exposing (Location)




main =
  Navigation.program SetRoute
      { init = init
      , view = view
      , update = update
      , subscriptions = \_ -> Sub.none
      }


initialModel : Model
initialModel =
    { response = "Waiting for a response ..."
    , token = Nothing
    , page = Home
    }

init : Location -> (Model, Cmd Msg)
init location =
  let
      initTuple =
       setRoute location initialModel
   in
       initTuple


-- Http.send FetchPeople (authedGraphRequest "" peopleQuery) ]
