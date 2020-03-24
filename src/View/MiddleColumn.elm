module View.MiddleColumn exposing (middleColumn)

import Compute exposing (Datum)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Model exposing (DisplayPage(..), Model, Msg(..), init)
import Widget.Button as Button exposing (Size(..), button)
import Widget.Style as Style
import Widget.TextArea as TextArea exposing (TextArea)


middleColumn model =
    let
        g =
            0.9
    in
    column [ alignTop, Background.color (Element.rgb g g g), padding 20 ]
        [ column [ centerX, spacing 10 ]
            [ textInput model
            , dataSummary model
            , dataSummaryByWeek model
            , row [ spacing 10 ] [ computeButton, clearButton, getSampleButton model ]
            ]
        ]


dataSummary : Model -> Element msg
dataSummary model =
    case model.timeSeries of
        Nothing ->
            Element.el [ Font.size 14 ] (text "No valid data yet")

        Just data ->
            let
                n =
                    List.length data |> String.fromInt

                dataPoints =
                    n ++ " data points"

                doublingTimeData =
                    Compute.doublingTime data

                doubling =
                    case doublingTimeData of
                        Nothing ->
                            "Bad data, could not compute doubling time"

                        Just dt ->
                            "doubling time = "
                                ++ String.fromFloat (Compute.roundTo 1 dt)
                                ++ " days"

                message =
                    String.join ", " [ dataPoints, doubling ]
            in
            Element.el [ Font.size 14, Font.color Style.lightRed ] (text message)


dataSummaryByWeek : Model -> Element Msg
dataSummaryByWeek model =
    case model.timeSeries of
        Nothing ->
            Element.el [ Font.size 14 ] (text "---")

        Just data ->
            let
                display x_ =
                    case x_ of
                        Nothing ->
                            " - "

                        Just x ->
                            Compute.roundTo 1 x |> String.fromFloat

                doublingTimes =
                    Compute.doublingTimes data
                        |> List.map display
                        |> String.join ", "

                message =
                    "Doubling times by week: " ++ doublingTimes
            in
            Element.el [ Font.size 14, Font.color Style.lightRed ] (text message)



--- WIDGETS


computeButton : Element Msg
computeButton =
    button Compute "Doubling time"
        |> Button.withStyle Button.Rounded
        |> Button.withWidth (Bounded 120)
        |> Button.toElement


clearButton : Element Msg
clearButton =
    button Clear "Clear"
        |> Button.withStyle Button.Rounded
        |> Button.withWidth (Bounded 80)
        |> Button.toElement


getSampleButton : Model -> Element Msg
getSampleButton model =
    button SampleData "Sample Data"
        |> Button.withStyle Button.Rounded
        |> Button.withWidth (Bounded 120)
        |> Button.toElement


textInput model =
    TextArea.input GotText model.data "Enter data separated by commas"
        |> TextArea.withWidth 400
        |> TextArea.withHeight 533
        |> TextArea.toElement
