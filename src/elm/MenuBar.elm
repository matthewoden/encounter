module MenuBar (..) where

import Signal exposing (Signal, Address)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, targetValue)


-- My modules

import Model exposing (..)
import Update exposing (..)
import Icons


roundStatus : Address Action -> Model -> Html
roundStatus address model =
  div
    [ class "round-status" ]
    [ div
        [ class "round-status__item" ]
        [ span
            [ class "round-status__label" ]
            [ text "Turn" ]
        , span
            [ class "round-status__value" ]
            [ text (toString model.turn) ]
        ]
    , div
        [ class "round-status__item" ]
        [ span
            [ class "round-status__label" ]
            [ text "Round" ]
        , span
            [ class "round-status__value" ]
            [ text (toString model.round) ]
        ]
    ]


roundControls : Address Action -> Bool -> Html
roundControls address shouldSort =
  let
    roundClasses =
      [ ( "round-controls", True )
      , ( "round-controls--should-sort", shouldSort )
      ]
  in
    section
      [ classList roundClasses ]
      [ button
          [ class "round-controls__button"
          , onClick address ReverseRound
          ]
          [ Icons.back ]
      , button
          [ class "round-controls__button"
          , onClick address AddCharacter
          ]
          [ Icons.sword ]
      , button
          [ class "round-controls__button"
          , onClick address SortCharacters
          ]
          [ span
              [ class "round-controls__badge" ]
              []
          , Icons.sort
          ]
      , button
          [ class "round-controls__button"
          , onClick address AdvanceRound
          ]
          [ Icons.forward ]
      ]


view : Address Action -> Model -> Html
view address model =
  div
    [ class "menubar" ]
    [ roundControls address model.remindToSort
    , roundStatus address model
    ]
