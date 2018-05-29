
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
    , contracts : List Contract
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
    = SetRoute Location
    | NavigateTo Route.Route
    | SetEmail String
    | SetPassword String
    | SetPasswordConf String
    | SetName String
    | SubmitSignUp
    | ReceiveRegistrationResponse RegistrationResponse
    | ReceivePeopleResponse PeopleResponse
    | GetPeople
    | SubmitSignIn
    | ReceiveSessionResponse SessionResponse
    | ReceiveContractsResponse ContractsResponse
    | FetchContracts 



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


type alias Session =
  { token : String
  }

type alias LoginDetails =
  { email : String
  , password : String
  }

type alias LoginInput =
  { input : LoginDetails }

type alias Contract =
  { id : String
  , cost : Float
  , endDate : String
  }

type alias ContractsResponse =
  Result GraphQLClient.Error (List Contract)

type alias Category =
  { id : String
  , name: String
  }

type alias Vendor =
  { id : String
  , name : String
  }

type alias SessionResponse =
  Result GraphQLClient.Error Session

type alias Registration =
  { id : String }

type alias RegistrationResponse =
  Result GraphQLClient.Error Registration
