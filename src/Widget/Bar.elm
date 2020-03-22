module Widget.Bar exposing (bar)

import Element exposing (Element)
import Svg exposing (Svg)
import Svg.Attributes as SA


bar : Float -> Float -> Element msg
bar total current =
    bar_ (current / total)


bar_ : Float -> Element msg
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
