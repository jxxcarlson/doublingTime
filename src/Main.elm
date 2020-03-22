module Main exposing (main)

import Browser
import CaseData exposing (CaseData)
import Compute exposing (Datum, roundTo)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Html exposing (Html)
import Model exposing (DisplayPage(..), Model, Msg(..), init)
import View.RightColumn exposing (rightColumn)
import View.Text as Text
import Widget.Bar exposing (bar)
import Widget.Button as Button exposing (Size(..), button)
import Widget.Style as Style
import Widget.TextArea as TextArea exposing (TextArea)


main =
    Browser.sandbox { init = init, view = view, update = update }



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        Compute ->
            let
                timeSeries =
                    Compute.timeSeries model.data

                stats =
                    Maybe.andThen Compute.logStatistics timeSeries
            in
            { model | timeSeries = timeSeries, statistics = stats }

        GotText str ->
            { model | data = str }

        Clear ->
            { model | data = "", timeSeries = Nothing, country = Nothing }

        LoadCountry country ->
            loadCountry country model

        SampleData ->
            { model | country = Just "Sample Data", data = Compute.france20200225DataAsString, timeSeries = Compute.timeSeries Compute.france20200225DataAsString }

        MarkdownMsg _ ->
            model

        SetDisplay displayPage ->
            { model | displayPage = displayPage }



-- HELPERS


loadCountry : String -> Model -> Model
loadCountry country model =
    let
        countryCases_ =
            List.filter (\data -> data.country == country) CaseData.cases |> List.head
    in
    case countryCases_ of
        Nothing ->
            model

        Just countryCases ->
            let
                cd =
                    countryCases.cases

                data =
                    cd |> List.map String.fromFloat |> String.join ", "
            in
            { model | country = Just countryCases.country, data = data, timeSeries = Compute.timeSeries data }



-- VIEW


view : Model -> Html Msg
view model =
    let
        g =
            0.4
    in
    Element.layoutWith { options = [ focusStyle Style.myFocusStyle ] } [ Background.color <| Element.rgb g g g ] (mainColumn model)


mainColumn : Model -> Element Msg
mainColumn model =
    row [ spacing 20, paddingXY 40 40 ]
        [ leftColumn model
        , middleColumn model
        , rightColumn model
        ]


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


leftColumn model =
    column
        [ Background.color (Element.rgb 1.0 1.0 1.0)
        , alignTop
        , padding 20
        ]
        [ el [ Font.bold, Font.size 18, paddingXY 0 12 ] (text "Doubling Time Estimator")
        , header model
        , case model.displayPage of
            About ->
                Text.viewAbout model |> Element.html

            Data ->
                dataView model

            Notes ->
                Text.viewNotes model |> Element.html
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
        , button (SetDisplay Notes) "Notes"
            |> Button.withSelected (model.displayPage == Notes)
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
            :: firstItem model.timeSeries
            :: viewDelta (model.timeSeries |> Maybe.withDefault [])
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
        , viewItem 40 <| "Cases"
        , viewItem 40 <| "Change"
        , viewItem 30 <| "%%"
        ]


firstItem : Maybe (List Float) -> Element msg
firstItem data =
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
        , viewItem 40 <| itemZero
        , viewItem 40 <| "N/A"
        , viewItem 30 <| "N/A"
        ]


viewDelta : List Float -> List (Element msg)
viewDelta data =
    let
        lastValue =
            List.head (List.reverse data) |> Maybe.withDefault 100000000

        viewDatum : Datum -> Element msg
        viewDatum datum =
            row [ spacing 10 ]
                [ viewItem 11 <| String.fromInt datum.index
                , viewItem 40 <| String.fromFloat <| roundTo 0 datum.data
                , viewItem 40 <| String.fromFloat <| roundTo 0 datum.delta
                , viewItem 30 <| String.padLeft 4 ' ' <| String.fromFloat <| roundTo 1 <| (\x -> x * 100.0) <| datum.relativeDelta
                , bar lastValue datum.data
                ]
    in
    List.map viewDatum (Compute.dataItems data)


viewItem w str =
    column [ width (px w) ] [ el [ alignRight ] (text str) ]


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
        |> Button.withWidth (Bounded 120)
        |> Button.toElement


clearButton : Element Msg
clearButton =
    button Clear "Clear"
        |> Button.withWidth (Bounded 80)
        |> Button.toElement


getSampleButton : Model -> Element Msg
getSampleButton model =
    button SampleData "Sample Data"
        |> Button.withWidth (Bounded 120)
        |> Button.toElement


textInput model =
    TextArea.input GotText model.data "Enter data separated by commas"
        |> TextArea.withWidth 400
        |> TextArea.withHeight 533
        |> TextArea.toElement
