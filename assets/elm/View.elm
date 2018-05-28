module View exposing (..)

import Html exposing(Html, text, div, button)
import Types exposing(Model, Msg(..), Page(..))
import Html.Attributes exposing(..)

view : Model -> Html Msg
view model =
    case model.page of 
        Home ->
            div [] [ (homeView model) ]
        
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


homeView : Model -> Html Msg 
homeView model =
    case model.token of 
        Nothing -> 
            div [ class "app-box"] 
                [ div [] [ text "Welcome to contracor"] 
                , div 
                    []
                    [ button [] [text "Sign Up"]
                    , button [] [text "Sign In"]
                    ]
                ]
        
        Just token -> 
            div [] [ text "Logged In" ]
    
