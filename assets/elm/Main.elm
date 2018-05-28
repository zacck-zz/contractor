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
    , token =""
    , page = Home 
    }

init : Location -> (Model, Cmd Msg)
init location = setRoute location initialModel ! [
 Http.send FetchPeople (authedGraphRequest "" peopleQuery) ]

