module View.LeftColumn exposing (leftColumn)

import Compute exposing (Datum, roundTo)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Model exposing (DisplayPage(..), Model, Msg(..), init)
import Utility.Calendar as Calendar
import View.Text as Text
import Widget.Bar
import Widget.Button as Button exposing (Size(..), button)
import Widget.Style as Style


leftColumn model =
    column
        [ Background.color (Element.rgb 1.0 1.0 1.0)
        , alignTop
        , padding 20
        ]
        [ el [ Font.bold, Font.size 18, paddingXY 0 12 ] (text "Coronavirus Pandemic and Doubling Times")
        , header model
        , case model.displayPage of
            About ->
                Text.viewAbout model |> Element.html

            Data ->
                dataView model

            Graphs ->
                Text.viewNotes model |> Element.html

            Articles ->
                Text.viewArticles model |> Element.html
        ]


header : Model -> Element Msg
header model =
    row [ width fill, spacing 12, Background.color Style.mediumGray ]
        [ button (SetDisplay Data) "Data"
            |> Button.withSelected (model.displayPage == Data)
            |> Button.withWidth (Bounded 80)
            |> Button.toElement
        , button (SetDisplay About) "About"
            |> Button.withSelected (model.displayPage == About)
            |> Button.withWidth (Bounded 80)
            |> Button.toElement
        , button (SetDisplay Graphs) "Graphs"
            |> Button.withSelected (model.displayPage == Graphs)
            |> Button.withWidth (Bounded 80)
            |> Button.toElement
        , button (SetDisplay Articles) "Articles"
            |> Button.withSelected (model.displayPage == Articles)
            |> Button.withWidth (Bounded 80)
            |> Button.toElement
        ]


dataView : Model -> Element msg
dataView model =
    column
        [ width (px 380)
        , height (px 568)
        , Background.color Style.pureWhite
        , Font.size 10
        , paddingXY 12 12
        , spacing 5
        , alignRight
        , scrollbarY
        ]
        (title model
            :: dataHeader
            :: firstItem model.monthOfFirstCase model.dayOfFirstCase model.timeSeries
            :: viewDelta model.monthOfFirstCase model.dayOfFirstCase (model.timeSeries |> Maybe.withDefault [])
        )


title : Model -> Element msg
title model =
    row [ Font.bold, Font.size 18, paddingXY 0 10 ]
        [ el [] (text (model.country |> Maybe.withDefault "---"))
        ]


dataHeader : Element msg
dataHeader =
    row [ spacing 10 ]
        [ viewItem 11 <| "n"
        , viewItem 20 <| "Date"
        , viewItem 35 <| "Cases"
        , viewItem 40 <| "Change"
        , viewItem 30 <| "%%"
        ]


firstItem : Int -> Int -> Maybe (List Float) -> Element msg
firstItem month day data =
    let
        itemZero =
            case data of
                Nothing ->
                    "-"

                Just data_ ->
                    Maybe.map (String.fromFloat << roundTo 0) (List.head data_) |> Maybe.withDefault "-"
    in
    row [ spacing 10 ]
        [ viewItem 11 <| "0"
        , viewItem 20 <| dateOfItem month day 0
        , viewItem 35 <| itemZero
        , viewItem 40 <| "N/A"
        , viewItem 30 <| "N/A"
        ]


viewDelta : Int -> Int -> List Float -> List (Element msg)
viewDelta month day data =
    let
        lastValue =
            List.head (List.reverse data) |> Maybe.withDefault 100000000

        viewDatum : Datum -> Element msg
        viewDatum datum =
            row [ spacing 10 ]
                [ viewItem 11 <| String.fromInt datum.index
                , viewItem 20 <| dateOfItem month day datum.index
                , viewItem 35 <| String.fromFloat <| roundTo 0 datum.data
                , viewItem 40 <| String.fromFloat <| roundTo 0 datum.delta
                , viewItem 30 <| String.padLeft 4 ' ' <| String.fromFloat <| roundTo 1 <| (\x -> x * 100.0) <| datum.relativeDelta
                , myBar lastValue datum.data
                ]
    in
    List.map viewDatum (Compute.dataItems data)


myBar maxValue value =
    Widget.Bar.make (value / maxValue)
        |> Widget.Bar.withRGBHex "#A00"
        |> Widget.Bar.toElement


dateOfItem : Int -> Int -> Int -> String
dateOfItem month_ day_ index =
    let
        baseIndex =
            Calendar.indexOfDate month_ day_

        adjustedIndex =
            index + baseIndex
    in
    Calendar.dateOfIndex adjustedIndex


viewItem w str =
    column [ width (px w) ] [ el [ alignRight ] (text str) ]
