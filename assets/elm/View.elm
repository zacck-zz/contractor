module View exposing (..)

import Html exposing(Html, text, div, a, button, input, label, li, ul, p)
import Types exposing(Model, Msg(..), Page(..), Contract)
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
            div [] [ (contractsView model.contracts) ]

        ContractDetails ->
            div [] [ (contractDetailsView model) ]

        SignIn ->
            div [] [ (loginView model) ]

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
                          , button [ onClick (NavigateTo Route.SignIn) ] [text "Sign In"]
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
              [ div [] [(formErrors model.errors)]
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


formErrors : List String -> Html msg
formErrors errors =
  errors
      |> List.map(\error -> li [] [ text error])
      |> ul []


loginView : Model -> Html Msg
loginView model =
    div [ class "app-box"]
        [ div [] [(formErrors model.errors)]
        , label [ class "label"]
          [ text "Email"
          , input [ type_ "text", placeholder "Your email address", onInput SetEmail, value model.email ] []
          ]
        , label [ class "label"]
          [ text "Password"
          , input [ type_ "password", onInput SetPassword, value model.password ] []
          ]
        , button [ onClick SubmitSignIn ] [ text "SIGN IN"]
        ]

contractsView : List Contract -> Html Msg
contractsView contractList =
  let
      list =
        case contractList of
          [] ->
            div []
                [ text "No contracts to show at the Moment"]
          contracts ->
            div []
                (List.map contractsRow contractList)
  in
    div [ class "app-box"]
        [ div []
              [ div [ class "contract-header"]
                    [ p [ class "page-title"] [ text "My Contracts"]
                    , button [onClick (NavigateTo Route.AddContract)][text "ADD CONTRACT"]]
              ]
        , div [ class "contracts-list"] [list]
        ]


contractDetailsView : Model -> Html Msg
contractDetailsView model =
    let
        activeId =
          model.activeContract

        activeContracts =
          List.filter (\c -> c.id == activeId) model.contracts
    in
        case activeContracts of
          [] ->
            div [ class "app-box"] [text ("Contract with id: " ++ activeId ++ " does not exisit")]
          x::xs ->
            div [ class "app-box"] [(contractView x)]


contractView : Contract -> Html Msg
contractView contract =
    div [ class "contract-page"]
        [ div [ class "contract-column"]
              [ p [ class "title"] [ text "Vendor"]
              , p [ class "value"] [ text contract.vendor.name]
              ]
        , div [ class "contract-column"]
              [ p [ class "title"] [ text "Category"]
              , p [ class "value"] [ text contract.category.name]
              ]
        , div [ class "contract-column"]
              [ p [ class "title"] [ text "Costs"]
              , p [ class "value"] [ text ("$ " ++ (toString contract.cost))]
              ]
        , div [ class "contract-column"]
              [ p [ class "title"] [ text "Ends On"]
              , p [ class "value"] [ text contract.endDate]
              ]
        , div [ class "c-buttons"]
              [ button [] [ text "EDIT"]
              , button [] [text "DELETE"]
              ]
        ]



contractsRow : Contract -> Html Msg
contractsRow contract =
    div [ class "contract-item", onClick (OpenContract contract.id)]
        [ div [ class "contract-column"]
              [ p [ class "title"] [ text "Vendor"]
              , p [ class "value"] [ text contract.vendor.name]
              ]
        , div [ class "contract-column"]
              [ p [ class "title"] [ text "Category"]
              , p [ class "value"] [ text contract.category.name]
              ]
        , div [ class "contract-column"]
              [ p [ class "title"] [ text "Costs"]
              , p [ class "value"] [ text ("$ " ++ (toString contract.cost))]
              ]
        , div [ class "contract-column"]
              [ p [ class "title"] [ text "Ends On"]
              , p [ class "value"] [ text contract.endDate]
              ]
        ]
