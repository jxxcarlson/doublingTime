module Main exposing (Model, Msg(..), buttonStyle, computeButton, indicator, indicatorStyle, init, main, mainColumn, mainColumnStyle, update, view)

{-| Simple counter app using mdgriffith/elm-ui
-}

import Browser
import CaseData exposing (CaseData)
import Compute
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


main =
    Browser.sandbox { init = init, view = view, update = update }



-- MODEL


type alias Model =
    { counter : Int
    , data : String
    , country : Maybe String
    , timeSeries : Maybe (List Float)
    , statistics : Maybe Statistics
    }


init : Model
init =
    { counter = 0
    , data = ""
    , country = Nothing
    , timeSeries = Nothing
    , statistics = Nothing
    }



-- UPDATE


type Msg
    = Compute
    | GotText String
    | SampleData
    | Clear
    | LoadCountry String
    | MarkdownMsg MarkdownMsg


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
            { model | country = Nothing, data = Compute.france20200225DataAsString, timeSeries = Compute.timeSeries Compute.france20200225DataAsString }

        MarkdownMsg _ ->
            model



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
    Element.layout [ Background.color <| Element.rgb g g g ] (mainColumn model)


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
    in
    column [ alignTop, Background.color (Element.rgb g g g), padding 20, Font.size 14, width (px 400), height (px 680), spacing 10 ]
        (List.map (casesForCountry model) CaseData.cases)


casesForCountry : Model -> CaseData -> Element Msg
casesForCountry model caseData =
    row [ spacing 15 ]
        [ loadCountryButton model caseData.country
        , el [ width (px 130), Font.size 13 ] (text caseData.note)
        , link [ width (px 100), Font.color (Element.rgb 0 0 0.8) ]
            { url = caseData.sourceLink
            , label = text "Source"
            }
        ]


loadCountryButton : Model -> String -> Element Msg
loadCountryButton model country =
    let
        color =
            case model.country of
                Nothing ->
                    Element.rgb 0 0 0

                Just targetCountry ->
                    case targetCountry == country of
                        True ->
                            Element.rgb 0.8 0 0

                        False ->
                            Element.rgb 0 0 0
    in
    row (buttonStyle2 100 color)
        [ Input.button (buttonStyle2 100 color)
            { onPress = Just (LoadCountry country)
            , label = el [ centerX, centerY ] (text country)
            }
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
            , row [ spacing 10 ] [ computeButton, clearButton, getSampleButton ]
            ]
        ]


leftColumn model =
    column
        [ Background.color (Element.rgb 1.0 1.0 1.0)
        , alignTop
        , Font.size 14
        , padding 20
        ]
        [ markdownText model |> Element.html ]


markdownText model =
    Html.div
        [ HA.style "width" "350px"
        , HA.style "height" "600px"
        , HA.style "overflow" "scroll"
        , HA.style "white-space" "normal"
        , HA.style "margin" "20px"
        , HA.style "font-size" "11px"
        , HA.style "line-height" "18px"
        ]
        [ Markdown.Render.toHtml ExtendedMath Strings.text
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
                                ++ String.fromFloat (Compute.roundTo 2 dt)
                                ++ " days"

                --++ " -- common ratio = "
                --++ (String.fromFloat <| Compute.roundTo 2 (Compute.commonRatio dt))
                message =
                    String.join ", " [ dataPoints, doubling ]
            in
            Element.el [ Font.size 14, Font.color (Element.rgb 0.8 0 0) ] (text message)


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
                            Compute.roundTo 2 x |> String.fromFloat

                doublingTimes =
                    Compute.doublingTimes data
                        |> List.map display
                        |> String.join ", "

                message =
                    "Doubling times by week: " ++ doublingTimes
            in
            Element.el [ Font.size 14, Font.color (Element.rgb 0.8 0 0) ] (text message)


indicator : Model -> Element msg
indicator model =
    row indicatorStyle
        [ el [ centerX, centerY ] (text (String.fromInt model.counter))
        ]


computeButton : Element Msg
computeButton =
    row buttonStyle
        [ Input.button buttonStyle
            { onPress = Just Compute
            , label = el [ centerX, centerY ] (text "Doubling time")
            }
        ]


clearButton : Element Msg
clearButton =
    row buttonStyle
        [ Input.button buttonStyle
            { onPress = Just Clear
            , label = el [ centerX, centerY ] (text "Clear")
            }
        ]


getSampleButton : Element Msg
getSampleButton =
    row buttonStyle
        [ Input.button buttonStyle
            { onPress = Just SampleData
            , label = el [ centerX, centerY ] (text "Sample Data")
            }
        ]


textInput model =
    Input.multiline [ width (px 400), height (px 533), Font.size 14 ]
        { onChange = GotText
        , text = model.data
        , placeholder = Nothing
        , label = Input.labelAbove [] (text "Enter data separated by commas")
        , spellcheck = False
        }



-- STYLE


indicatorStyle =
    [ width <| px 80
    , height <| px 80
    , Background.color (rgb255 40 40 40)
    , Font.color (rgb255 255 0 0)
    , Font.size 50
    ]


buttonStyle2 w color =
    [ paddingXY 8 2
    , height <| px 30
    , width <| px w
    , Background.color color
    , Font.color (rgb255 240 240 240)
    , Font.size 14
    ]


buttonStyle =
    [ paddingXY 8 2
    , height <| px 30
    , Background.color (rgb255 120 120 120)
    , Font.color (rgb255 240 240 240)
    , Font.size 14
    ]


mainColumnStyle =
    [ centerX
    , centerY
    , width (px 800)
    ]
