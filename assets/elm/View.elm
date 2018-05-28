module View exposing (..)

import Html exposing(Html, text, div, a, button)
import Types exposing(Model, Msg(..), Page(..))
import Html.Events exposing(onClick)
import Html.Attributes exposing(..)
import State exposing(setRoute)
import Route

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
                [ div [ class "home-box"]
                      [ div [ class "message"] [ text "Welcome to contractor"]
                      , div
                          []
                          [ button [ onClick (NavigateTo Route.SignUp) ] [text "Sign Up"]
                          , button [ onClick (NavigateTo Route.SignUp) ] [text "Sign In"]
                          ]
                      ]
                ]

        Just token ->
            div []
                [ a [ onClick <| NavigateTo Route.Contracts ]
                    [ text "Go to Contracts"]
                ]
