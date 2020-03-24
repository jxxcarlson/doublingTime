module Widget.Button exposing
    ( Role(..)
    , Size(..)
    , Variant(..)
    , button
    , toElement
    , withAlignment
    , withBackgroundColor
    , withFontColor
    , withHeight
    , withRole
    , withSelected
    , withSelectedBackgroundColor
    , withSelectedFontColor
    , withStyle
    , withWidth
    )

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
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
    , variant : Variant
    , selected : Bool
    , backgroundColor : Color
    , fontColor : Color
    , selectedBackgroundColor : Color
    , selectedFontColor : Color
    , borderColor : Color
    , width : Size
    , height : Size
    , alignment : Alignment
    }


type Role
    = Primary
    | Outline


type Variant
    = Square
    | Rounded


type Alignment
    = Left
    | Center


type Size
    = Bounded Int
    | Unbounded


defaultOptions =
    { role = Primary
    , variant = Square
    , selected = False
    , backgroundColor = Style.darkGray
    , fontColor = Style.white
    , selectedBackgroundColor = Style.darkRed
    , selectedFontColor = Style.white
    , borderColor = Style.white
    , width = Unbounded
    , height = Bounded 30
    , alignment = Center
    }


toElement : Button msg -> Element msg
toElement (Button options msg label) =
    if options.selected then
        button_ (buttobuttonStyleDispatcher options.role) options.variant options.width options.height options.selectedBackgroundColor options.selectedFontColor msg label

    else
        button_ (buttobuttonStyleDispatcher options.role) options.variant options.width options.height options.backgroundColor options.fontColor msg label


withRole : Role -> Button msg -> Button msg
withRole role (Button options msg label) =
    Button { options | role = role } msg label


withStyle : Variant -> Button msg -> Button msg
withStyle variant (Button options msg label) =
    Button { options | variant = variant } msg label


withAlignment : Alignment -> Button msg -> Button msg
withAlignment alignment (Button options msg label) =
    Button { options | alignment = alignment } msg label


withWidth : Size -> Button msg -> Button msg
withWidth size (Button options msg label) =
    Button { options | width = size } msg label


withHeight : Size -> Button msg -> Button msg
withHeight size (Button options msg label) =
    Button { options | height = size } msg label


withSelected : Bool -> Button msg -> Button msg
withSelected flag (Button options msg label) =
    Button { options | selected = flag } msg label


withBackgroundColor : Color -> Button msg -> Button msg
withBackgroundColor color (Button options msg label) =
    Button { options | backgroundColor = color } msg label


withFontColor : Color -> Button msg -> Button msg
withFontColor color (Button options msg label) =
    Button { options | fontColor = color } msg label


withSelectedBackgroundColor : Color -> Button msg -> Button msg
withSelectedBackgroundColor color (Button options msg label) =
    Button { options | selectedBackgroundColor = color } msg label


withSelectedFontColor : Color -> Button msg -> Button msg
withSelectedFontColor color (Button options msg label) =
    Button { options | selectedFontColor = color } msg label


type alias InnerButton msg =
    ButtonStyleFunction msg -> Variant -> Size -> Size -> Color -> Color -> msg -> String -> Element msg


button_ : InnerButton msg
button_ buttonStyleFunction variant w h bgColor color msg_ label =
    row (buttonStyleFunction variant w h bgColor color)
        [ Input.button [ paddingXY 4 4, centerX ]
            { onPress = Just msg_
            , label = el [ centerX, centerY ] (text label)
            }
        ]


buttobuttonStyleDispatcher : Role -> ButtonStyleFunction msg
buttobuttonStyleDispatcher role =
    case role of
        Primary ->
            primaryButtonStyle

        Outline ->
            outlineButtonStyle


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


type alias ButtonStyleFunction msg =
    Variant -> Size -> Size -> Color -> Color -> List (Attribute msg)


variantStyle : Variant -> Color -> List (Attribute msg)
variantStyle variant color =
    case variant of
        Square ->
            []

        Rounded ->
            [ Border.rounded 8
            , Border.color color
            ]


primaryButtonStyle : ButtonStyleFunction msg
primaryButtonStyle variant width_ height_ bgColor color =
    [ paddingXY 0 2
    , Background.color bgColor
    , Font.color color
    , Font.size 14
    , mouseDown [ Background.color (rgb255 40 40 200) ]
    ]
        ++ variantStyle variant color
        |> prependWidth width_
        |> prependWidth height_


outlineButtonStyle : ButtonStyleFunction msg
outlineButtonStyle variant width_ height_ bgColor color =
    [ paddingXY 0 2
    , Background.color bgColor
    , Font.color color
    , Font.size 14
    , Border.solid
    , Border.color (Element.rgb255 255 0 0)
    , Border.width 2
    , mouseDown [ Background.color (rgb255 40 40 200) ]
    ]
        ++ variantStyle variant color
        |> prependWidth width_
        |> prependWidth height_
