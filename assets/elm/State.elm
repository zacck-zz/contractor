module State exposing(..)

import Types exposing (Model, Msg(..), Page(..), SignUpInput,  Registration, RegistrationResponse, Person, SignUpDetails,PeopleResponse, LoginInput)
import Types exposing (CategoriesInput, LoginDetails, Session, Category, PlainVendor, LoadedVendor, Contract, ContractResult, ContractInput, ContractInputDetails)
import Utils exposing (validateSignUp, validateAuth, validateSignIn, sendAuthedMutation, sendAuthedQuery, vendorConfig, categoryConfig, validateContract)
import Navigation exposing (Location)
import UrlParser
import Route exposing (toPath)
import GraphQL.Request.Builder exposing (..)
import GraphQL.Request.Builder.Arg as Arg
import GraphQL.Request.Builder.Variable as Var
import Task exposing (Task)
import Select
import Debug


-- addUser Mutation
addUserMutation : SignUpInput -> Request Mutation Registration
addUserMutation signUpInput =
    let
        inputVar =
          Var.required "input"
              .input
              (Var.object "AddUserInput"
                  [ Var.field "name" .name Var.string
                  , Var.field "email" .email Var.string
                  , Var.field "hash" .hash Var.string
                  ]
              )
     in
        extract
            (field "addUser"
              [ ("input", Arg.variable inputVar) ]
              (object Registration
                    |> with (field "id" [] string)
              )
            )
            |> mutationDocument
            |> request
                { input =  signUpInput.input }


-- addContract Mutation
addContractMutation : ContractInput -> Request Mutation ContractResult
addContractMutation contractInput =
    let
        inputVar =
          Var.required "input"
              .input
              (Var.object "ContractInput"
                  [ Var.field "person_id" .person_id Var.string
                  , Var.field "vendor_id" .vendor_id Var.string
                  , Var.field "end_date" .end_date Var.string
                  , Var.field "cost" .cost Var.float
                  , Var.field "category_id" .category_id Var.string
                  ]
              )
    in
       extract
          (field "addUserContract"
            [("input", Arg.variable inputVar)]
            (object ContractResult
                  |> with (field "id" [] string)
                  |> with (field "endDate" [] string)
                  |> with (field "cost" [] float)
            )
          )
          |> mutationDocument
          |> request
              { input = contractInput.input }


-- login Mutation
loginMutation : LoginInput -> Request Mutation Session
loginMutation loginInput =
    let
        inputVar =
          Var.required "input"
              .input
              (Var.object "LoginInput"
                  [ Var.field "password" .password Var.string
                  , Var.field "email" .email Var.string
                  ]
              )

        person =
          object Person
            |> with (field "id" [] string)
            |> with (field "name" [] string)
            |> with (field "email" [] string)

    in
      extract
        (field "login"
          [("input", Arg.variable inputVar)]
          (object Session
                |> with (field "token" [] string)
                |> with (field "person" [] person)
          )
        )
        |> mutationDocument
        |> request
              { input = loginInput.input }


-- query for a users contracts
contractsQuery : Request Query (List Contract)
contractsQuery =
  let
    category =
      object Category
          |> with (field "id" [] string)
          |> with (field "name" [] string)

    vendor =
      object PlainVendor
          |> with (field "id" [] string)
          |> with (field "name" [] string)

  in
    extract
      (field "contracts"
          []
          (list
              (object Contract
                    |> with (field "id" [] string)
                    |> with (field "cost" [] float)
                    |> with (field "endDate" [] string)
                    |> with (field "category" [] category)
                    |> with (field "vendor" [] vendor)
              )
          )
      )
      |> queryDocument
      |> request
            {}

-- query the vendors graph
vendorsQuery : Request Query (List LoadedVendor)
vendorsQuery =
    let
        category =
          object Category
              |> with (field "id" [] string)
              |> with (field "name" [] string)
    in
      extract
        (field "vendors"
          []
          (list
              (object LoadedVendor
                    |> with (field "id" [] string)
                    |> with (field "name" [] string)
                    |> with (field "categories" [] (list category))
              )
          )
        )
        |> queryDocument
        |> request
              {}

-- query categories end endpoint
categoriesQuery : CategoriesInput -> Request Query (List Category)
categoriesQuery categoriesInput =
    let
        inputVar =
          Var.required "id" .id Var.id
    in
        extract
          (field "categories"
            [("id", Arg.variable inputVar)]
            (list
                (object Category
                      |> with (field "id" [] string)
                      |> with (field "name" [] string)
                )
            )
          )
          |> queryDocument
          |> request
                { id = categoriesInput.id }




-- query for people
peopleQuery : Request Query (List Person)
peopleQuery =
    extract
      (field "people"
        []
        (list
            (object Person
                |> with (field "id" [] string)
                |> with (field "name" [] string)
                |> with (field "email" [] string)
            )
        )
      )
      |> queryDocument
      |> request
            {}



-- login reques dispatch
sendSignInRequest : LoginInput -> Model -> Cmd Msg
sendSignInRequest loginInput model =
    sendAuthedMutation model (loginMutation loginInput)
      |> Task.attempt ReceiveSessionResponse


-- signup request
sendSignUpRequest : SignUpInput -> Model -> Cmd Msg
sendSignUpRequest signUpInput model =
    sendAuthedMutation model (addUserMutation signUpInput)
          |> Task.attempt ReceiveRegistrationResponse

-- send add contract request
sendAddContractRequest : ContractInput -> Model -> Cmd Msg
sendAddContractRequest contractInput model =
    sendAuthedMutation model (addContractMutation contractInput)
          |> Task.attempt ReceiveAddContractResponse

-- people request
sendPeopleRequest : Model -> Cmd Msg
sendPeopleRequest model =
    sendAuthedQuery model peopleQuery
      |> Task.attempt ReceivePeopleResponse

-- contracts request
sendContractsRequest : Model -> Cmd Msg
sendContractsRequest model =
    sendAuthedQuery model contractsQuery
      |> Task.attempt ReceiveContractsResponse

-- available vendots request
sendVendorsRequest : Model -> Cmd Msg
sendVendorsRequest model =
    sendAuthedQuery model vendorsQuery
      |> Task.attempt ReceiveVendorsResponse

--send for available categories
sendCategoriesRequest : CategoriesInput -> Model -> Cmd Msg
sendCategoriesRequest categoriesInput model =
    sendAuthedQuery model (categoriesQuery categoriesInput)
      |> Task.attempt ReceiveCategoriesResponse




-- parsePath reads the path in the url and turns it into a new type
setRoute : Location -> Model -> (Model, Cmd Msg)
setRoute location model =
    let
       route =
        UrlParser.parsePath Route.route location
           |> Maybe.withDefault Route.Home
    in
        case route of
            Route.Home ->
                ({ model | page = Home }, Cmd.none)
            Route.Contracts ->
                let
                    cmd =
                      case validateAuth model of
                        [] ->
                           (sendContractsRequest model)
                        errors ->
                          (Navigation.newUrl <| toPath Route.SignIn)
                in
                ({ model | page = Contracts }, cmd)
            Route.ContractDetails ->
                ({ model | page = ContractDetails }, Cmd.none)
            Route.SignIn ->
                ({ model | page = SignIn }, Cmd.none)
            Route.SignUp ->
                ({ model | page = SignUp }, Cmd.none)
            Route.AddContract ->
              let
                  cmd =
                    case validateAuth model of
                      [] ->
                         (sendVendorsRequest model)
                      errors ->
                        (Navigation.newUrl <| toPath Route.SignIn)
              in
                ({ model | page = AddContract }, cmd)
            Route.UpdateContract ->
                ({ model | page = UpdateContract }, Cmd.none)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
   case msg of
     SetRoute location ->
         ( setRoute location model)
     NavigateTo route ->
       (model , (Navigation.newUrl <| toPath route))
     SetEmail email ->
       ({ model | email = email}, Cmd.none)
     SetPassword password ->
       ({ model | password = password }, Cmd.none)
     SetPasswordConf passwordconf ->
       ({ model | passwordconf = passwordconf}, Cmd.none)
     SetName name ->
       ({ model | name = name }, Cmd.none)
     SubmitSignUp ->
       case validateSignUp model of
         [] ->
           (model, (sendSignUpRequest { input = (SignUpDetails model.name model.email model.password)} model))
         errors ->
           ({ model | errors = errors}, Cmd.none)
     GetPeople ->
       (model, (sendPeopleRequest model))
     ReceiveRegistrationResponse response ->
       case response of
         Ok result ->
           ({ model | loggedId = Just result.id }, (Navigation.newUrl <| toPath Route.SignIn))

         Err err ->
           ({ model | errors = [ toString err ]}, Cmd.none)
     ReceivePeopleResponse response ->
       let
           people =
             case response of
               Ok result ->
                 result

               Err err ->
                 []
       in
          ({ model | people = people}
          , Cmd.none)

     SubmitSignIn ->
      case validateSignIn model of
        [] ->
          (model, (sendSignInRequest { input = (LoginDetails model.email model.password)} model))
        errors ->
          ({ model | errors = errors}, Cmd.none)
     ReceiveSessionResponse response ->
      case response of
        Ok result ->
          ( { model | token = result.token , loggedId = Just result.person.id }, (Navigation.newUrl <| toPath Route.Contracts))

        Err err ->
          ({ model | errors = [toString err] }, Cmd.none)
     ReceiveContractsResponse response ->
      case response of
        Ok result ->
          ({ model | contracts = result }, Cmd.none)

        Err err ->
          ({ model | errors = [toString err]}, Cmd.none)

     FetchContracts ->
        case validateAuth model of
          [] ->
            (model, (sendContractsRequest model))
          errors ->
            ({ model | errors = errors }, (Navigation.newUrl <| toPath Route.SignIn))
     OpenContract id ->
        ({ model | activeContract = id }, (Navigation.newUrl <| toPath Route.ContractDetails))
     SetNewContractCost cost ->
       let
           newCost =
             Result.withDefault 0 (String.toFloat cost)
       in
        ({ model | contractCost = newCost }, Cmd.none)
     SetNewContractEnds ends ->
       ( { model | endsDate = ends }, Cmd.none)
     SetNewContractVendor vendorId ->
       ( { model | contractVendor = vendorId }, Cmd.none)
     SetNewContractCategory categoryId ->
       ( { model | contractCategory = categoryId}, Cmd.none)
     OnVendorSelect maybeLoadedVendor ->
       let
           vendorId =
             Maybe.map .id maybeLoadedVendor

           stringId =
             case vendorId of
               Nothing ->
                 ""
               Just id ->
                 id
       in
       ({ model | selectedVendorId = vendorId, contractVendor = stringId}, (sendCategoriesRequest (CategoriesInput stringId) model))
     OnCategorySelect maybeCategory ->
        let
            categoryId =
              Maybe.map .id maybeCategory

            stringCatId =
              case categoryId of
                Nothing ->
                  ""
                Just id ->
                  id
        in
            ({ model | selectedCategoryId = categoryId, contractCategory = stringCatId}, Cmd.none)
     SaveContract ->
       let
           personId =
             case model.loggedId of
               Nothing ->
                 ""
               Just id ->
                   id
       in
         case validateContract model of
           [] ->
             (model, (sendAddContractRequest { input = (ContractInputDetails personId model.contractCategory model.contractVendor model.contractCost model.endsDate)} model))
           errors ->
             ( { model | errors = errors }, Cmd.none)
     VendorQuery  query ->
       (model, (sendVendorsRequest model))
     CategoryQuery query ->
       case model.selectedVendorId of
         Nothing ->
           ({ model | errors = ["Please select a Vendor to load Categories"]}, Cmd.none)
         Just id ->
           ( model, (sendCategoriesRequest (CategoriesInput id) model))
     ReceiveCategoriesResponse response ->
       case response of
         Ok result ->
           ({ model | availableCategories = result}, Cmd.none)

         Err err ->
           ({ model | errors = [toString err]}, Cmd.none)

     ReceiveVendorsResponse response ->
       case response of
         Ok result ->
           ({ model | availableVendors = result }, Cmd.none)

         Err err ->
           ( { model | errors = [toString err]}, Cmd.none)
     SelectVendor subMsg ->
       let
           (updated, cmd) =
             Select.update vendorConfig subMsg model.vendorSelectState
       in
          ({ model | vendorSelectState = updated}, cmd)
     SelectCategory subMsg ->
       let
            (updated, cmd) =
              Select.update categoryConfig subMsg model.categorySelectState
       in
          ({ model | categorySelectState = updated}, cmd)
     ReceiveAddContractResponse resp ->
       case resp of
         Ok result ->
           (model, (Navigation.newUrl <| toPath Route.Contracts))

         Err err ->
           ( { model | errors = [toString err]}, Cmd.none)
