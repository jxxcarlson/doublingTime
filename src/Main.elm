module Main exposing (Model, Msg(..), buttonStyle, computeButton, indicator, indicatorStyle, init, main, mainColumn, mainColumnStyle, update, view)

{-| Simple counter app using mdgriffith/elm-ui
-}

import Browser
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
    , timeSeries : Maybe (List Float)
    , statistics : Maybe Statistics
    }


init : Model
init =
    { counter = 0
    , data = ""
    , timeSeries = Nothing
    , statistics = Nothing
    }



-- UPDATE


type Msg
    = Compute
    | GotText String
    | SampleData
    | Clear
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
            { model | data = "", timeSeries = Nothing }

        SampleData ->
            { model | data = Compute.france20200225DataAsString, timeSeries = Compute.timeSeries Compute.france20200225DataAsString }

        MarkdownMsg _ ->
            model



-- VIEW


view : Model -> Html Msg
view model =
    let
        g =
            0.4
    in
    Element.layout [ Background.color <| Element.rgb g g g ] (mainColumn model)


mainColumn model =
    row [ spacing 20, paddingXY 40 40 ]
        [ leftColumn model
        , rightColumn model
        ]


rightColumn model =
    let
        g =
            0.9
    in
    column [ alignTop, Background.color (Element.rgb g g g), padding 20 ]
        [ column [ centerX, spacing 10 ]
            [ textInput model
            , dataSummary model
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
        , HA.style "font-size" "12px"
        , HA.style "line-height" "15px"
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

                doublingTime =
                    Compute.doublingTime data

                doubling =
                    case doublingTime of
                        Nothing ->
                            "Bad data, could not compute doubling time"

                        Just dt ->
                            "doubling time = " ++ String.fromFloat (Compute.roundTo 2 dt) ++ " days"

                message =
                    String.join ", " [ dataPoints, doubling ]
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
    Input.multiline [ width (px 400), height (px 557), Font.size 14 ]
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
