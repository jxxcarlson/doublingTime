module View.Text exposing (viewAbout, viewNotes)

import Html
import Html.Attributes as HA
import Markdown.Option exposing (..)
import Markdown.Render exposing (MarkdownMsg)
import Msg exposing (Msg(..))
import Strings


viewAbout model =
    Html.div
        [ HA.style "width" "340px"
        , HA.style "height" "528px"
        , HA.style "overflow" "scroll"
        , HA.style "white-space" "normal"
        , HA.style "margin" "20px"
        , HA.style "font-size" "11px"
        , HA.style "line-height" "18px"
        ]
        [ Markdown.Render.toHtml ExtendedMath Strings.text
            |> Html.map MarkdownMsg
        ]


viewNotes model =
    Html.div
        [ HA.style "width" "340px"
        , HA.style "height" "528px"
        , HA.style "overflow" "scroll"
        , HA.style "white-space" "normal"
        , HA.style "margin" "20px"
        , HA.style "font-size" "11px"
        , HA.style "line-height" "18px"
        ]
        [ Markdown.Render.toHtml ExtendedMath Strings.notes
            |> Html.map MarkdownMsg
        ]
