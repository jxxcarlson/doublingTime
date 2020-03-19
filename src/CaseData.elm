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
    , cases =
        [ 13
        , 18
        , 38
        , 57
        , 100
        , 130
        , 191
        , 212
        , 285
        , 423
        , 613
        , 949
        , 1126
        , 1412
        , 1784
        , 2281
        , 2876
        , 3661
        , 4449
        , 4499
        , 5423
        , 6633
        , 7730
        , 9134
        ]
    , sourceLink = "https://en.wikipedia.org/wiki/2020_coronavirus_outbreak_in_France#Timeline_2"
    , sourceName = "Wikipedia"
    , country = "France"
    , note = "Feb 25 to Mar 18, 2020"
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
        , 17660
        , 21157
        , 27980
        , 31506
        , 35713
        ]
    , sourceLink = "https://en.wikipedia.org/wiki/Template:2019%E2%80%9320_coronavirus_pandemic_data/Italy_medical_cases"
    , sourceName = "Wikipedia"
    , country = "Italy"
    , note = "Feb 21 to Mar 18, 2020"
    }


southKorea =
    { startDate = "2020-1-20"
    , cases =
        [ 1
        , 1
        , 1
        , 1
        , 2
        , 2
        , 3
        , 4
        , 5
        , 5
        , 6
        , 11
        , 12
        , 15
        , 15
        , 16
        , 19
        , 23
        , 24
        , 24
        , 27
        , 27
        , 28
        , 28
        , 28
        , 28
        , 28
        , 29
        , 30
        , 31
        , 51
        , 104
        , 204
        , 433
        , 602
        , 833
        , 977
        , 1261
        , 1766
        , 2337
        , 3150
        , 4212
        , 4812
        , 5328
        , 5760
        , 6284
        , 6767
        , 7134
        , 7382
        , 7513
        , 7755
        , 7869
        , 7979
        , 8086
        , 8162
        , 8236
        , 8320
        , 8413
        , 8565
        ]
    , sourceName = "Wikipedia"
    , sourceLink = "https://en.wikipedia.org/wiki/2020_coronavirus_pandemic_in_South_Korea"
    , country = "South Korea"
    , note = "Jan 20 to Mar 18, 2020 (*)"
    }


usa =
    { startDate = "2020-2-27"
    , cases =
        [ 15
        , 19
        , 24
        , 42
        , 57
        , 85
        , 111
        , 175
        , 252
        , 352
        , 495
        , 643
        , 936
        , 1205
        , 1598
        , 2163
        , 2825
        , 3497
        , 4372
        , 5656
        , 8054
        ]
    , sourceName = "Wikipedia"
    , sourceLink = "https://en.wikipedia.org/wiki/2020_coronavirus_pandemic_in_the_United_States"
    , country = "USA"
    , note = "Feb 27 to Mar 18, 2020"
    }
