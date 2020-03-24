module Main exposing (main)

import Browser
import CaseData exposing (CaseData)
import Compute exposing (Datum)
import Element exposing (..)
import Element.Background as Background
import Html exposing (Html)
import Model exposing (DisplayPage(..), Model, Msg(..), init)
import View.LeftColumn exposing (leftColumn)
import View.MiddleColumn exposing (middleColumn)
import View.RightColumn exposing (rightColumn)
import Widget.Style as Style


main =
    Browser.sandbox { init = init, view = view, update = update }


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
            { model
                | country = Just countryCases.country
                , data = data
                , timeSeries = Compute.timeSeries data
                , displayPage = Data
                , monthOfFirstCase = countryCases.startMonth
                , dayOfFirstCase = countryCases.startDay
            }



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
        , rightColumn model
        , middleColumn model
        ]
