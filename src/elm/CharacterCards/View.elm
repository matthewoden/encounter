module CharacterCards.View (..) where

import Signal exposing (Signal, Address)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, targetValue, keyCode, onFocus)


-- My modules

import Model exposing (..)
import Update exposing (..)
import Inputs.Inputs exposing (initiativeInput, healthInput, changeHealthInput, nameInput)
import Icons


view : Address Action -> Model -> Html
view address model =
  model.characters
    |> List.map (card address model.tabItem)
    |> section [ class "sidebar" ]


card : Address Action -> String -> Character -> Html
card address tabItem character =
  let
    componentName =
      "card__"
  in
    div
      [ classList
          [ ( "card", True )
          , ( "card--active", character.active )
          , ( "card--holding", character.holding )
          , ( "card--selected", character.selected )
          ]
      , onClick address (SetSelected character.id)
      ]
      [ div
          [ class "card__status" ]
          [ nameInput address tabItem componentName character
          , div
              [ class "card__input-row" ]
              [ initiativeInput address tabItem componentName character
              , healthInput address tabItem componentName character
              , changeHealthInput address tabItem componentName character
              ]
          ]
      , controls address character
      ]


controls : Address Action -> Character -> Html
controls address character =
  let
    holdAction =
      if character.holding == False then
        (HoldAction character.id character.actsOnTurn)
      else
        (ResumeAction character.id character.initiative)
  in
    div
      [ class "card__action-bar" ]
      [ div
          [ class "card__action"
          , onClick address (JumpToCharacterTurn character.id character.actsOnTurn)
          ]
          [ Icons.crown character.active
          , text "Turn"
          ]
      , div
          [ class "card__action"
          , onClick address holdAction
          ]
          [ Icons.hold character.active
          , text "Hold"
          ]
      , div
          [ class "card__action"
          , onClick address (CopyCharacter character)
          ]
          [ Icons.copy character.active
          , text "Copy"
          ]
      , div
          [ class "card__action"
          , onClick address (RemoveCharacter character.id character.actsOnTurn)
          ]
          [ Icons.close character.active
          , text "Remove"
          ]
      ]
