
module Types exposing (..)
import Http
import Navigation exposing (Location)
import Route
import GraphQL.Client.Http as GraphQLClient
import Select


type alias Model =
    { response : String
    , token : String
    , page : Page
    , name : String
    , email : String
    , password : String
    , passwordconf : String
    , errors : List String
    , loggedId : Maybe String
    , contractCategory : String
    , contractCost : Float
    , contractVendor : String
    , endsDate : String
    , people : List Person
    , contracts : List Contract
    , activeContract : String
    , vendorSelectState : Select.State
    , selectedVendorId : Maybe String
    , availableVendors : List LoadedVendor
    , categorySelectState : Select.State
    , selectedCategoryId : Maybe String
    , availableCategories : List Category
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
    | OpenContract String
    | SaveContract
    | SetNewContractCost String
    | SetNewContractEnds String
    | SetNewContractCategory String
    | SetNewContractVendor String
    | OnVendorSelect (Maybe LoadedVendor)
    | VendorQuery String
    | ReceiveVendorsResponse LoadedVendorResponse
    | SelectVendor (Select.Msg LoadedVendor)
    | OnCategorySelect (Maybe Category)
    | CategoryQuery String
    | SelectCategory (Select.Msg Category)
    | ReceiveCategoriesResponse CategoriesResponse
    | ReceiveAddContractResponse AddContractResponse



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
  , person : Person
  }

type alias LoginDetails =
  { email : String
  , password : String
  }

type alias LoginInput =
  { input : LoginDetails }

type alias CategoriesInput =
  { id : String }

type alias CategoriesResponse =
  Result GraphQLClient.Error (List Category)

type alias Contract =
  { id : String
  , cost : Float
  , endDate : String
  , category : Category
  , vendor : PlainVendor
  }

type alias ContractResult =
  { id : String
  , endDate : String
  , cost : Float
  }

type alias AddContractResponse =
  Result GraphQLClient.Error ContractResult

type alias ContractInput =
  { input : ContractInputDetails}

type alias ContractInputDetails =
  { person_id : String
  , category_id : String
  , vendor_id : String
  , cost : Float
  , end_date : String
  }

type alias ContractsResponse =
  Result GraphQLClient.Error (List Contract)

type alias Category =
  { id : String
  , name: String
  }

type alias LoadedVendor =
  { id : String
  , name : String
  , categories : List Category
  }

type alias PlainVendor =
  { id : String
  , name : String
  }

type alias LoadedVendorResponse =
 Result GraphQLClient.Error (List LoadedVendor)

type alias PlainVendorResponse =
  Result GraphQLClient.Error (List PlainVendor)

type alias SessionResponse =
  Result GraphQLClient.Error Session

type alias Registration =
  { id : String }

type alias RegistrationResponse =
  Result GraphQLClient.Error Registration
