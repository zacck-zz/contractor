
module Types exposing (..)
import Http
import Navigation exposing (Location)

type alias Model = 
    { response : String
    , token : String
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


type alias Person =  
    { id : String
    , name : String 
    , email : String 
    }
