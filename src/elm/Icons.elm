module Icons where

import Svg exposing (Svg, svg, path)
import Svg.Attributes exposing (d, class, height, fill, width, viewBox)
{-
Source grabbed from https://materialdesignicons.com/
-}
plus : Svg
plus =
  svg [ class "icon "
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
  svg [ class "icon icon--text-right"
      , height "24"
      , width "24"
      , viewBox "0 0 24 24"
      ]
      [ path
          [ d "M6.92,5H5L14,14L15,13.06M19.96,19.12L19.12,19.96C18.73,20.35 18.1,20.35 17.71,19.96L14.59,16.84L11.91,19.5L10.5,18.09L11.92,16.67L3,7.75V3H7.75L16.67,11.92L18.09,10.5L19.5,11.91L16.83,14.58L19.95,17.7C20.35,18.1 20.35,18.73 19.96,19.12Z" ]
          []
      ]


sort : Svg
sort =
  svg [ class "icon icon--text-right"
      , height "24"
      , width "24"
      , viewBox "0 0 24 24"
      ]
      [ path
          [ d "M10,13V11H18V13H10M10,19V17H14V19H10M10,7V5H22V7H10M6,17H8.5L5,20.5L1.5,17H4V4H6V17Z" ]
          []
      ]


back : Svg
back =
  svg [ class "icon icon--text-right"
      , height "24"
      , width "24"
      , viewBox "0 0 24 24"
      ]
      [ path
          [ d "M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z" ]
          []
      ]


forward : Svg
forward =
  svg [ class "icon icon--text-left"
      , height "24"
      , width "24"
      , viewBox "0 0 24 24"
      ]
      [ path
          [ d "M4,11V13H16L10.5,18.5L11.92,19.92L19.84,12L11.92,4.08L10.5,5.5L16,11H4Z" ]
          []
      ]


close : Bool -> Svg
close active =
  let
    -- no classlist option in elm-svg
    classes =
      if active then
        "icon"
      else
        "icon--dark"
  in
    svg [ class classes
        , height "24"
        , width "24"
        , viewBox "0 0 24 24"
        ]
        [ path
            [ d "M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z" ]
            []
        ]

crown : Bool -> Svg
crown active =
  let
    -- no classlist option in elm-svg
    classes =
      if active then
        "icon"
      else
        "icon--dark"
  in
    svg [ class classes
        , height "24"
        , width "24"
        , viewBox "0 0 24 24"
        ]
        [ path
            [ d "M5,16L3,5L8.5,12L12,5L15.5,12L21,5L19,16H5M19,19A1,1 0 0,1 18,20H6A1,1 0 0,1 5,19V18H19V19Z" ]
            []
        ]
