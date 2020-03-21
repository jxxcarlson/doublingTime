module Widget exposing (selectedButton, standardButton)

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Style exposing (..)


selectedButton w msg label flag =
    case flag of
        False ->
            standardButton w msg label

        True ->
            selectedButton_ w msg label


selectedButton_ w msg label =
    button_ w darkRed white msg label


standardButton w msg label =
    button_ w darkGray white msg label


button_ w bgColor color msg label =
    row (buttonStyle w bgColor color)
        [ Input.button (buttonStyle w bgColor color)
            { onPress = Just msg
            , label = el [ centerX, centerY ] (text label)
            }
        ]


buttonStyle w bgColor color =
    [ paddingXY 8 2
    , height <| px 30
    , width <| px w
    , Background.color bgColor
    , Font.color color
    , Font.size 14
    , mouseDown [ Background.color (rgb255 40 40 200) ]
    ]
