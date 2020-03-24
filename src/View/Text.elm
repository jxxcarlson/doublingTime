module View.Text exposing (viewAbout, viewArticles, viewNotes)

import Html
import Html.Attributes as HA
import Markdown.Option exposing (..)
import Markdown.Render exposing (MarkdownMsg)
import Model exposing (Msg(..))
import View.Strings as Strings


viewAbout model =
    Html.div
        viewStyle
        [ Markdown.Render.toHtml ExtendedMath Strings.text
            |> Html.map MarkdownMsg
        ]


viewNotes model =
    Html.div
        viewStyle
        [ Markdown.Render.toHtml ExtendedMath Strings.graphs
            |> Html.map MarkdownMsg
        ]


viewArticles model =
    Html.div
        viewStyle
        [ Markdown.Render.toHtml ExtendedMath Strings.articles
            |> Html.map MarkdownMsg
        ]


viewStyle =
    [ HA.style "width" "340px"
    , HA.style "height" "528px"
    , HA.style "overflow" "scroll"
    , HA.style "white-space" "normal"
    , HA.style "margin" "20px"
    , HA.style "font-size" "11px"
    , HA.style "line-height" "18px"
    ]
