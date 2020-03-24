module Model exposing (DisplayPage(..), Model, Msg(..), init)

import Compute
import Markdown.Render exposing (MarkdownMsg)
import Stat exposing (Statistics)


type alias Model =
    { counter : Int
    , data : String
    , country : Maybe String
    , timeSeries : Maybe (List Float)
    , statistics : Maybe Statistics
    , displayPage : DisplayPage
    , monthOfFirstCase : Int
    , dayOfFirstCase : Int
    }


type Msg
    = Compute
    | GotText String
    | SampleData
    | Clear
    | LoadCountry String
    | MarkdownMsg MarkdownMsg
    | SetDisplay DisplayPage


type DisplayPage
    = About
    | Data
    | Graphs
    | Articles


init : Model
init =
    { counter = 0
    , data = Compute.france20200225DataAsString
    , country = Just "Sample Data"
    , timeSeries = Compute.timeSeries Compute.france20200225DataAsString
    , statistics = Nothing
    , displayPage = Data
    , monthOfFirstCase = 0
    , dayOfFirstCase = 0
    }
