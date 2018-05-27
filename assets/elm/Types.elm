
module Types exposing (..)
import Http

type alias Model = 
    { response : String
    , token : String 
    }


type Msg
    = FetchPeople (Result Http.Error String)


type alias Person =  
    { id : String
    , name : String 
    , email : String 
    }
