module Widget.Button exposing (Size(..), button, toElement, withSelected, withWidth)

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Widget.Style as Style exposing (..)


type Button msg
    = Button Options msg String


button : msg -> String -> Button msg
button msg label =
    Button defaultOptions msg label


type alias Options =
    { role : Role
    , selected : Bool
    , backgroundColor : Color
    , fontColor : Color
    , selectedBackgroundColor : Color
    , selectedFontColor : Color
    , width : Size
    , height : Size
    }


type Size
    = Bounded Int
    | Unbounded


defaultOptions =
    { role = Primary
    , selected = False
    , backgroundColor = Style.darkGray
    , fontColor = Style.white
    , selectedBackgroundColor = Style.darkRed
    , selectedFontColor = Style.white
    , width = Unbounded
    , height = Bounded 30
    }


toElement : Button msg -> Element msg
toElement (Button options msg label) =
    if options.selected then
        button_ options.width options.height options.selectedBackgroundColor options.selectedFontColor msg label

    else
        button_ options.width options.height options.backgroundColor options.fontColor msg label


type Role
    = Primary
    | Secondary


withWidth : Size -> Button msg -> Button msg
withWidth size (Button options msg label) =
    Button { options | width = size } msg label


withSelected : Bool -> Button msg -> Button msg
withSelected flag (Button options msg label) =
    Button { options | selected = flag } msg label


selectedButton w msg label flag =
    case flag of
        False ->
            standardButton w msg label

        True ->
            selectedButton_ w msg label


selectedButton_ w msg label =
    button_ w (Bounded 30) darkRed white msg label


standardButton w msg label =
    button_ w (Bounded 30) darkGray white msg label


button_ w h bgColor color msg label =
    row (buttonStyle w h bgColor color)
        [ Input.button (buttonStyle w h bgColor color)
            { onPress = Just msg
            , label = el [ centerX, centerY ] (text label)
            }
        ]


prependWidth : Size -> List (Attribute msg) -> List (Attribute msg)
prependWidth size list =
    case size of
        Unbounded ->
            list

        Bounded w ->
            (width <| px w) :: list


prependHeight : Size -> List (Attribute msg) -> List (Attribute msg)
prependHeight size list =
    case size of
        Unbounded ->
            list

        Bounded h ->
            (height <| px h) :: list


buttonStyle : Size -> Size -> Color -> Color -> List (Attribute msg)
buttonStyle width_ height_ bgColor color =
    [ paddingXY 0 2
    , Background.color bgColor
    , Font.color color
    , Font.size 14
    , mouseDown [ Background.color (rgb255 40 40 200) ]
    ]
        |> prependWidth width_
        |> prependWidth height_
