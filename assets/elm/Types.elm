
module Types exposing (..)
import Http
import Navigation exposing (Location)
import Route

type alias Model =
    { response : String
    , token : Maybe String
    , page : Page
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


type alias Person =
    { id : String
    , name : String
    , email : String
    }
