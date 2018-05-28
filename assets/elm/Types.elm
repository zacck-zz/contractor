
module Types exposing (..)
import Http
import Navigation exposing (Location)
import Route

type alias Model =
    { response : String
    , token : Maybe String
    , page : Page
    , name : String
    , email : String
    , password : String
    , passwordconf : String
    , errors : List String
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



type alias Person =
    { id : String
    , name : String
    , email : String
    }
