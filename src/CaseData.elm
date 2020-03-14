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
    [ france, italy, usa, southKorea ]


france =
    { startDate = "2020-2-25"
    , cases = [ 13, 18, 38, 57, 100, 130, 191, 212, 285, 423, 613, 949, 1126, 1412, 1784, 2281, 2876, 3661, 4449 ]
    , sourceLink = "https://en.wikipedia.org/wiki/2020_coronavirus_outbreak_in_France#Timeline_2"
    , sourceName = "Wikipedia"
    , country = "France"
    , note = "Feb 25 to Mar 13, 2020"
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
        , 15113
        ]
    , sourceLink = "https://en.wikipedia.org/wiki/Template:2019%E2%80%9320_coronavirus_pandemic_data/Italy_medical_cases"
    , sourceName = "Wikipedia"
    , country = "Italy"
    , note = "Feb 21 to Mar 12, 2020"
    }


southKorea =
    { startDate = "2020-1-20"
    , cases =
        [ 4
        , 27
        , 39
        , 51
        , 61
        , 122
        , 183
        , 244
        , 308
        , 371
        , 429
        , 518
        , 607
        , 714
        , 885
        , 1130
        , 1886
        , 2598
        , 3113
        , 3629
        , 4487
        , 5345
        , 6203
        , 7061
        , 7919
        , 8171
        , 9265
        , 11173
        , 13207
        , 16400
        , 21586
        , 25577
        , 31923
        , 40304
        , 53553
        , 66653
        , 81167
        , 94055
        , 109951
        , 128851
        , 136707
        , 146541
        , 164740
        , 178189
        , 188518
        , 196618
        , 210144
        , 223395
        , 234998
        , 248647
        ]
    , sourceName = "Wikipedia"
    , sourceLink = "https://en.wikipedia.org/wiki/2020_coronavirus_pandemic_in_South_Korea"
    , country = "South Korea"
    , note = "Jan 20 to Mar 12, 2020 (*)"
    }


usa =
    { startDate = "2020-2-27"
    , cases = [ 15, 19, 24, 42, 57, 85, 111, 175, 252, 352, 495, 643, 932, 1200, 1561 ]
    , sourceName = "Wikipedia"
    , sourceLink = "https://en.wikipedia.org/wiki/2020_coronavirus_pandemic_in_the_United_States"
    , country = "USA"
    , note = "Feb 27 to Mar 12, 2020"
    }
