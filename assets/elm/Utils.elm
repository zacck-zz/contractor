module Utils exposing (..)


import Json.Encode as Encode 
import Json.Decode as Decode exposing(Decoder)
import Json.Decode.Pipeline as Pipeline 
import Http
import Types exposing(Person)


-- Url for the graphql endpoint
graphUrl : String
graphUrl =
    "http://localhost:4000/api/graph"

-- Encode query object
queryEncoder : String -> Encode.Value
queryEncoder query =
    Encode.object
      [("query", Encode.string query)]


-- Creates a jsonBody of a query
queryBody : String -> Http.Body
queryBody data =
  let
    body =
      data
        |> queryEncoder
        |> Http.jsonBody
   in
    body



-- Decoder for person graph
personDecoder : Decoder Person 
personDecoder =
    Pipeline.decode Person 
        |> Pipeline.required "id" Decode.string 
        |> Pipeline.required "name" Decode.string 
        |> Pipeline.required "email" Decode.string




-- build authenticated graphRequest
authedGraphRequest : String  -> String -> Http.Request String
authedGraphRequest  token body =
  { method = "POST"
  , headers = [ Http.header "Authorization" ("Bearer " ++ token)]
  , url = graphUrl
  , body = body |> queryBody
  , expect =  Http.expectString
  , timeout = Nothing
  , withCredentials = False
  }
    |> Http.request



