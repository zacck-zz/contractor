
module Types exposing (..)
import Http
import Navigation exposing (Location)
import Route
import GraphQL.Client.Http as GraphQLClient


type alias Model =
    { response : String
    , token : String
    , page : Page
    , name : String
    , email : String
    , password : String
    , passwordconf : String
    , errors : List String
    , registration : Maybe Registration
    , people : List Person
    }



type Page
   = Home
   | Contracts
   | ContractDetails
   | SignIn
   | SignUp
   | AddContract
   | UpdateContract



type Msg
    = FetchPeople (Result Http.Error String)
    | SetRoute Location
    | NavigateTo Route.Route
    | SetEmail String
    | SetPassword String
    | SetPasswordConf String
    | SetName String
    | SubmitSignUp
    | ReceiveRegistrationResponse RegistrationResponse
    | ReceivePeopleResponse PeopleResponse
    | GetPeople



type alias Person =
    { id : String
    , name : String
    , email : String
    }



type alias PeopleResponse =
  Result GraphQLClient.Error (List Person)

type alias SignUpInput =
  { input: SignUpDetails }

type alias SignUpDetails =
  { name : String
  , email :  String
  , hash : String
  }

type alias Registration =
  { id : String }

type alias RegistrationResponse =
  Result GraphQLClient.Error Registration
