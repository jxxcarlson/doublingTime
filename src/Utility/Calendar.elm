module Utility.Calendar exposing (dateOfIndex, indexOfDate)


daysInMonths : List Int
daysInMonths =
    [ 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ]


daysToEndOfMonth : List Int
daysToEndOfMonth =
    [ 31, 60, 91, 120, 152, 182, 213, 244, 274, 305, 335, 366 ]


dateOfIndex : Int -> String
dateOfIndex index =
    let
        monthOfIndex index_ =
            List.filter (\n -> n < index_) daysToEndOfMonth
                |> List.length
                |> (\x -> x + 1)

        m =
            monthOfIndex index

        dd =
            dayThroughMonth (m - 1)

        d =
            index - dd
    in
    String.fromInt m ++ "/" ++ String.fromInt d


indexOfDate : Int -> Int -> Int
indexOfDate month day =
    dayThroughMonth (month - 1) + day


dayThroughMonth : Int -> Int
dayThroughMonth m =
    List.take m daysInMonths
        |> List.sum
