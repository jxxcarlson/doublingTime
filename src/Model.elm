module Model exposing (DisplayPage(..), Model, Msg(..), init)

import CaseData
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
    let
        data =
            CaseData.france.cases |> List.map String.fromInt |> String.join ", "
    in
    { counter = 0
    , data = data
    , country = Just "France"
    , timeSeries = Compute.timeSeries data
    , statistics = Nothing
    , displayPage = Data
    , monthOfFirstCase = 0
    , dayOfFirstCase = 0
    }
