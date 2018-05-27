module View exposing (..)

import Html exposing(Html, text, div)
import Types exposing(Model, Msg(..))


view : Model -> Html Msg
view model =
    div [] [ text model.response ]
