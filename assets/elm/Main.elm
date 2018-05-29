module Main exposing (..)

import Html exposing(Html)
import Http
import Types exposing (Model, Msg(..), Page(..), Contract, Vendor, Category)
import State exposing (update, setRoute)
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
    , token = ""
    , page = Home
    , name = ""
    , email = ""
    , password = ""
    , passwordconf = ""
    , errors = []
    , registration = Nothing
    , people = []
    , contracts = [Contract "r64r6r5t676t6t" 690.23 "2018-12-05"
                  , Contract "gy6yf6u7uyghug" 873.98 "2018-11-05" ]
    }

init : Location -> (Model, Cmd Msg)
init location =
  let
      initTuple =
       setRoute location initialModel
   in
       initTuple


-- Http.send FetchPeople (authedGraphRequest "" peopleQuery) ]
