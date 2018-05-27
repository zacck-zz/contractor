module State exposing(..)


import Http 
import Json.Encode as Encode 
import Json.Decode as Decode 
import Types exposing (Model, Msg(..))
import Utils exposing (graphUrl, queryBody, authedGraphRequest)

-- Draw up a people query
peopleQuery : String
peopleQuery =
    """
    {
      people {
        id
        name
      }
    }
    """



update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
   case msg of
     FetchPeople response ->
       case response of
         Ok result ->
             ({ model | response = result }, Cmd.none)

         Err err ->
           ({ model | response = toString err }, Cmd.none)




