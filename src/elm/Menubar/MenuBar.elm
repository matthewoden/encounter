module MenuBar.MenuBar (view) where

import Signal exposing (Signal, Address)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, targetValue)


-- My modules

import Model exposing (..)
import Update exposing (..)
import Menubar.Icons as Icons


view : Address Action -> Model -> Html
view address model =
  div
    [ class "menubar" ]
    [ roundControls address model.remindToSort
    , roundStatus address model
    ]


roundStatus : Address Action -> Model -> Html
roundStatus address model =
  div
    [ class "round-status" ]
    [ div
        [ class "round-status__item" ]
        [ span
            [ class "round-status__value" ]
            [ text (toString model.turn) ]
        , span
            [ class "round-status__label" ]
            [ text "Turn" ]
        ]
    , div
        [ class "round-status__item" ]
        [ span
            [ class "round-status__value" ]
            [ text (toString model.round) ]
        , span
            [ class "round-status__label" ]
            [ text "Round" ]
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
          [ Icons.back
          , span
              [ class "round-controls__label" ]
              [ text "back" ]
          ]
      , button
          [ class "round-controls__button"
          , onClick address AddCharacter
          ]
          [ Icons.sword
          , span
              [ class "round-controls__label" ]
              [ text "add" ]
          ]
      , button
          [ class "round-controls__button"
          , onClick address SortCharacters
          ]
          [ span
              [ class "round-controls__badge" ]
              []
          , Icons.sort
          , span
              [ class "round-controls__label" ]
              [ text "Sort" ]
          ]
      , button
          [ class "round-controls__button"
          , onClick address AdvanceRound
          ]
          [ Icons.forward
          , span
              [ class "round-controls__label" ]
              [ text "next" ]
          ]
      ]
