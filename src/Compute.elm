module Compute exposing (doublingTime, e, france20200225DataAsString, logStatistics, mean, roundTo, timeSeries)

import Maybe.Extra
import Stat exposing (Statistics)


e =
    2.7138


france20200225DataAsString =
    [ 13, 18, 38, 57, 100, 130, 191, 212, 285, 423, 613, 949, 1126, 1412, 1784 ]
        |> List.map String.fromInt
        |> String.join ", "


timeSeries : String -> Maybe (List Float)
timeSeries data =
    data
        |> String.split ","
        |> List.map String.trim
        |> List.map String.toFloat
        |> Maybe.Extra.combine


statistics : List Float -> Maybe Statistics
statistics timeSeries_ =
    timeSeries_
        |> List.indexedMap (\i y -> ( toFloat i, y ))
        |> Stat.statistics


logStatistics : List Float -> Maybe Statistics
logStatistics timeSeries_ =
    statistics (List.map (logBase e) timeSeries_)


doublingTime : List Float -> Maybe Float
doublingTime timeSeries_ =
    case logStatistics timeSeries_ of
        Nothing ->
            Nothing

        Just stats ->
            let
                k =
                    stats.m
            in
            Just <| logBase e 2.0 / k


mean : List Float -> Maybe Float
mean data =
    let
        s =
            List.sum data

        n =
            List.length data
    in
    case n of
        0 ->
            Nothing

        _ ->
            Just (s / toFloat n)


roundTo : Int -> Float -> Float
roundTo k x =
    let
        factor =
            10 ^ toFloat k
    in
    round (factor * x)
        |> toFloat
        |> (\u -> u / factor)
