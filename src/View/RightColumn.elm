module View.RightColumn exposing (rightColumn)

import CaseData exposing (CaseData)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Model exposing (Model, Msg(..))
import Widget.Button as Button exposing (Size(..), button)


rightColumn model =
    let
        g =
            0.9

        rightColumHeader =
            el [ Font.bold, Font.size 18, paddingXY 0 12 ] (text "Coronavirus Data by Country")
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
    button (LoadCountry country) country
        |> Button.withAlignment Button.Left
        |> Button.withSelected (model.country == Just country)
        |> Button.withWidth (Bounded 100)
        |> Button.toElement
