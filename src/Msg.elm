module Msg exposing (DisplayPage(..), Msg(..))

import Markdown.Render exposing (MarkdownMsg)


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
    | Notes
