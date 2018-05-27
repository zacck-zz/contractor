
module Types exposing (..)
import Http

type alias Model = 
    { response : String
    }


type Msg
    = FetchPeople (Result Http.Error String)

