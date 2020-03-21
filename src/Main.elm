module Main exposing (Model, Msg(..), computeButton, indicator, indicatorStyle, init, main, mainColumn, update, view)

{-| Simple counter app using mdgriffith/elm-ui
-}

import Browser
import CaseData exposing (CaseData)
import Compute exposing (Datum, roundTo)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Html.Attributes as HA
import Markdown.Option exposing (..)
import Markdown.Render exposing (MarkdownMsg)
import Stat exposing (Statistics)
import Strings
import Style
import Svg exposing (Svg)
import Svg.Attributes as SA
import Widget


main =
    Browser.sandbox { init = init, view = view, update = update }



-- MODEL


type alias Model =
    { counter : Int
    , data : String
    , country : Maybe String
    , timeSeries : Maybe (List Float)
    , statistics : Maybe Statistics
    , displayPage : DisplayPage
    }


type DisplayPage
    = About
    | Data
    | Notes


init : Model
init =
    { counter = 0
    , data = Compute.france20200225DataAsString
    , country = Just "Sample Data"
    , timeSeries = Compute.timeSeries Compute.france20200225DataAsString
    , statistics = Nothing
    , displayPage = Data
    }



-- UPDATE


type Msg
    = Compute
    | GotText String
    | SampleData
    | Clear
    | LoadCountry String
    | MarkdownMsg MarkdownMsg
    | SetDisplay DisplayPage


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


rightColumn model =
    let
        g =
            0.9

        rightColumHeader =
            el [ Font.bold, Font.size 18 ] (text "Covid-19 Data by Country")
    in
    column
        [ alignTop
        , Background.color (Element.rgb g g g)
        , padding 20
        , Font.size 14
        , width (px 400)
        , height (px 680)
        , spacing 10
        ]
        (rightColumHeader :: List.map (casesForCountry model) CaseData.cases)


casesForCountry : Model -> CaseData -> Element Msg
casesForCountry model caseData =
    row [ spacing 15 ]
        [ loadCountryButton model caseData.country
        , el [ width (px 140), Font.size 13 ] (text caseData.note)
        , link [ width (px 100), Font.color (Element.rgb 0 0 0.8) ]
            { url = caseData.sourceLink
            , label = text "Source"
            }
        ]


loadCountryButton : Model -> String -> Element Msg
loadCountryButton model country =
    Widget.selectedButton 100 (LoadCountry country) country (model.country == Just country)


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
                markdownText model |> Element.html

            Data ->
                dataView model

            Notes ->
                articleView model |> Element.html
        ]


header : Model -> Element Msg
header model =
    row [ paddingXY 12 0, width fill, spacing 12, Background.color Style.mediumGray ]
        [ Widget.selectedButton 80 (SetDisplay Data) "Data" (model.displayPage == Data)
        , Widget.selectedButton 80 (SetDisplay About) "About" (model.displayPage == About)
        , Widget.selectedButton 80 (SetDisplay Notes) "Notes" (model.displayPage == Notes)
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


markdownText model =
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


articleView model =
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


indicator : Model -> Element msg
indicator model =
    row indicatorStyle
        [ el [ centerX, centerY ] (text (String.fromInt model.counter))
        ]


computeButton : Element Msg
computeButton =
    Widget.standardButton 120 Compute "Doubling time"


clearButton : Element Msg
clearButton =
    Widget.standardButton 80 Clear "Clear"


getSampleButton : Model -> Element Msg
getSampleButton model =
    Widget.selectedButton 120 SampleData "Sample Data" (model.country == Just "Sample Data")


textInput model =
    Input.multiline [ width (px 400), height (px 533), Font.size 14 ]
        { onChange = GotText
        , text = model.data
        , placeholder = Nothing
        , label = Input.labelAbove [] (text "Enter data separated by commas")
        , spellcheck = False
        }



-- SVG


bar total toDate =
    bar_ (toDate / total)


bar_ fraction =
    let
        h =
            10

        w =
            180
    in
    Svg.svg
        [ SA.transform "scale(1,1)"
        , SA.transform "translate(25, 0)"
        , SA.height <| String.fromFloat h
        , SA.width <| String.fromFloat w
        ]
        [ barRect "#A00" w h 0 fraction ]
        |> Element.html


barRect : String -> Float -> Float -> Float -> Float -> Svg msg
barRect color barWidth barHeight x fraction =
    Svg.rect
        [ SA.height <| String.fromFloat barHeight
        , SA.width <| String.fromFloat <| fraction * barWidth
        , SA.x <| String.fromFloat x
        , SA.fill color
        ]
        []



-- STYLE


indicatorStyle =
    [ width <| px 80
    , height <| px 80
    , Background.color (rgb255 40 40 40)
    , Font.color (rgb255 255 0 0)
    , Font.size 50
    ]
