module Icons (..) where

import Svg exposing (Svg, svg, path)
import Svg.Attributes exposing (d, class, height, fill, width, viewBox)


{-
Source grabbed from https://materialdesignicons.com/
-}


plus : Svg
plus =
  svg
    [ class "icon "
    , height "24"
    , width "24"
    , viewBox "0 0 24 24"
    ]
    [ path
        [ d "M19,13H13V19H11V13H5V11H11V5H13V11H19V13Z" ]
        []
    ]


sword : Svg
sword =
  svg
    [ class "icon icon--text-right"
    , height "24"
    , width "24"
    , viewBox "0 0 24 24"
    ]
    [ path
        [ d "M6.92,5H5L14,14L15,13.06M19.96,19.12L19.12,19.96C18.73,20.35 18.1,20.35 17.71,19.96L14.59,16.84L11.91,19.5L10.5,18.09L11.92,16.67L3,7.75V3H7.75L16.67,11.92L18.09,10.5L19.5,11.91L16.83,14.58L19.95,17.7C20.35,18.1 20.35,18.73 19.96,19.12Z"
        ]
        []
    ]


sort : Svg
sort =
  svg
    [ class "icon icon--text-right"
    , height "24"
    , width "24"
    , viewBox "0 0 24 24"
    ]
    [ path
        [ d "M10,13V11H18V13H10M10,19V17H14V19H10M10,7V5H22V7H10M6,17H8.5L5,20.5L1.5,17H4V4H6V17Z"
        ]
        []
    ]


back : Svg
back =
  svg
    [ class "icon icon--text-right"
    , height "24"
    , width "24"
    , viewBox "0 0 24 24"
    ]
    [ path
        [ d "M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"
        ]
        []
    ]


forward : Svg
forward =
  svg
    [ class "icon icon--text-left"
    , height "24"
    , width "24"
    , viewBox "0 0 24 24"
    ]
    [ path
        [ d "M4,11V13H16L10.5,18.5L11.92,19.92L19.84,12L11.92,4.08L10.5,5.5L16,11H4Z" ]
        []
    ]



-- A higher order component for icons that change based on a true/false property


activeIcon : Bool -> List Svg.Attribute -> List Svg -> Svg
activeIcon active attributeList elements =
  let
    -- no classlist option in elm-svg
    classes =
      if active then
        "icon"
      else
        "icon--dark"

    svgAttributes =
      [ class classes ] ++ attributeList
  in
    svg svgAttributes elements


close : Bool -> Svg
close active =
  activeIcon
    active
    [ height "24"
    , width "24"
    , viewBox "0 0 24 24"
    ]
    [ path
        [ d "M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z"
        ]
        []
    ]


crown : Bool -> Svg
crown active =
  activeIcon
    active
    [ height "24"
    , width "24"
    , viewBox "0 0 24 24"
    ]
    [ path
        [ d "M5,16L3,5L8.5,12L12,5L15.5,12L21,5L19,16H5M19,19A1,1 0 0,1 18,20H6A1,1 0 0,1 5,19V18H19V19Z"
        ]
        []
    ]


hold : Bool -> Svg
hold active =
  activeIcon
    active
    [ height "24"
    , width "24"
    , viewBox "0 0 24 24"
    ]
    [ path
        [ d "M12,20A7,7 0 0,1 5,13A7,7 0 0,1 12,6A7,7 0 0,1 19,13A7,7 0 0,1 12,20M19.03,7.39L20.45,5.97C20,5.46 19.55,5 19.04,4.56L17.62,6C16.07,4.74 14.12,4 12,4A9,9 0 0,0 3,13A9,9 0 0,0 12,22C17,22 21,17.97 21,13C21,10.88 20.26,8.93 19.03,7.39M11,14H13V8H11M15,1H9V3H15V1Z"
        ]
        []
    ]


copy : Bool -> Svg
copy active =
  activeIcon
    active
    [ height "24"
    , width "24"
    , viewBox "0 0 24 24"
    ]
    [ path
        [ d "M11,17H4A2,2 0 0,1 2,15V3A2,2 0 0,1 4,1H16V3H4V15H11V13L15,16L11,19V17M19,21V7H8V13H6V7A2,2 0 0,1 8,5H19A2,2 0 0,1 21,7V21A2,2 0 0,1 19,23H8A2,2 0 0,1 6,21V19H8V21H19Z"
        ]
        []
    ]
