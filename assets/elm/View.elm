module View exposing (..)

import Html exposing(Html, text, div, a, button, input, label, li, ul)
import Types exposing(Model, Msg(..), Page(..))
import Html.Events exposing(onClick, onInput)
import Html.Attributes exposing(..)
import State exposing(setRoute)
import Route
import String




view : Model -> Html Msg
view model =
    case model.page of
        Home ->
            div [] [ (homeView model) ]

        Contracts ->
            div [] [ text "Contracts" ]

        ContractDetails ->
            div [] [ text "ContractDetails" ]

        SignIn ->
            div [] [ text "Login Page" ]

        SignUp ->
            div [] [ (signUpView model) ]

        AddContract ->
            div [] [ text "Add Contract" ]

        UpdateContract ->
            div [] [ text "Update Contract" ]


homeView : Model -> Html Msg
homeView model =
    case String.isEmpty model.token of
        True ->
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

        False ->
            div []
                [ a [ onClick <| NavigateTo Route.Contracts ]
                    [ text "Go to Contracts"]
                ]


signUpView : Model -> Html Msg
signUpView model =
    div [ class "app-box" ]
        [ div [ class "home-box" ]
              [ div [] [(signUpErrors model.errors)]
              , label [ class "label"]
                [ text "Name"
                , input [ type_ "text", placeholder "Type your name", onInput SetName, value model.name ] []
                ]
              , label [ class "label"]
                [ text "Email"
                , input [ type_ "text", placeholder "Your email address", onInput SetEmail, value model.email ] []
                ]
              , label [ class "label"]
                [ text "Password"
                , input [ type_ "password", onInput SetPassword, value model.password ] []
                ]
              , label [ class "label"]
                [ text "Password Confirmation"
                , input [ type_ "password", onInput SetPasswordConf, value model.passwordconf] []
                ]
              , button [ onClick SubmitSignUp ] [ text "SIGN UP"]
              ]
        ]


signUpErrors : List String -> Html msg
signUpErrors errors =
  errors
      |> List.map(\error -> li [] [ text error])
      |> ul []
