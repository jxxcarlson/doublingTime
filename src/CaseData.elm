module CaseData exposing (CaseData, cases)


type alias CaseData =
    { startDate : String
    , cases : List Float
    , sourceLink : String
    , sourceName : String
    , country : String
    , note : String
    }


cases =
    [ france, italy ]


france =
    { startDate = "2020-2-25"
    , cases = [ 13, 18, 38, 57, 100, 130, 191, 212, 285, 423, 613, 949, 1126, 1412, 1784 ]
    , sourceLink = "https://en.wikipedia.org/wiki/2020_coronavirus_outbreak_in_France#Timeline_2"
    , sourceName = "Wikipedia"
    , country = "France"
    , note = "Feb 25 to Mar 10, 2020"
    }


italy =
    { startDate = "2020-2-21"
    , cases =
        [ 20
        , 79
        , 150
        , 227
        , 320
        , 445
        , 650
        , 888
        , 1128
        , 1694
        , 2036
        , 2502
        , 3089
        , 3859
        , 4630
        , 5883
        , 7370
        , 9172
        , 10149
        , 12462
        ]
    , sourceLink = "https://en.wikipedia.org/wiki/Template:2019%E2%80%9320_coronavirus_pandemic_data/Italy_medical_cases"
    , sourceName = "Wikipedia"
    , country = "Italy"
    , note = "Feb 2 to Mar 11, 2020"
    }
