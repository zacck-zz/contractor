module View exposing (..)

import Html exposing(Html, text, div)
import Types exposing(Model, Msg(..), Page(..))


view : Model -> Html Msg
view model =
    case model.page of 
        Home ->
            div [] [ text model.response ]
        
        Contracts ->
            div [] [ text "Contracts" ]
        
        ContractDetails ->
            div [] [ text "COntractDetails" ]
        
        SignIn -> 
            div [] [ text "Login Page" ]
        
        SignUp ->
            div [] [ text "Sign Up Page" ]
        
        AddContract ->
            div [] [ text "Add Contract" ]
        
        UpdateContract ->
            div [] [ text "Update Contract" ]


