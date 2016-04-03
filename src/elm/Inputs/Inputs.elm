module Inputs.Inputs (..) where

import Signal exposing (Signal, Address)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, targetValue, keyCode, onFocus)
import Json.Encode


-- My modules

import Model exposing (..)
import Update exposing (..)
import Utils.Input exposing (onEnter, onInput)


{-
The name field for a character
-}


notes : Address Action -> Character -> Html
notes address character =
  let
    fieldName =
      "Notes"
  in
    div
      [ class "notes" ]
      [ label
          [ class "notes__label" ]
          [ text "Notes" ]
      , textarea
          [ class "notes__textarea"
          , id (fieldName ++ toString character.id)
          , spellcheck False
          , name fieldName
          , placeholder "Enter notes about this combatant"
          , onInput address (UpdateNotes character.id)
          , value character.notes
          ]
          []
      ]


nameInput : Address Action -> String -> String -> Character -> Html
nameInput address tabItem componentName character =
  let
    inputName =
      "Name"

    nameInput =
      cardInput address inputName character.actsOnTurn tabItem

    componentClass =
      inputClasses componentName
  in
    div
      [ componentClass [ "input-group" ] ]
      [ label
          [ componentClass [ "label" ] ]
          [ text "name" ]
      , nameInput
          [ componentClass [ "name", "input" ]
          , placeholder "Name (Click to edit)"
          , onInput address (UpdateName character.id)
          , property "defaultValue" (Json.Encode.string character.name)
          ]
      ]


initiativeInput : Address Action -> String -> String -> Character -> Html
initiativeInput address tabItem componentName character =
  let
    inputName =
      "Initiative"

    initiativeInput =
      cardInput address inputName character.actsOnTurn tabItem

    componentClass =
      inputClasses componentName
  in
    div
      [ componentClass [ "input-group" ] ]
      [ label
          [ componentClass [ "label", "centered-text" ] ]
          [ text "Initiative" ]
      , initiativeInput
          [ componentClass [ "initiative", "input" ]
          , placeholder "0"
          , onInput address (UpdateInit character.id)
          , onEnter address SortCharacters
          , maxlength 5
          , property "defaultValue" (Json.Encode.string character.initiative)
          ]
      ]


healthInput : Address Action -> String -> String -> Character -> Html
healthInput address tabItem componentName character =
  let
    currentHealthName =
      "CurrentHealth"

    maxHealthName =
      "MaxHealth"

    currentHealthInput =
      cardInput address currentHealthName character.actsOnTurn tabItem

    maxHealthInput =
      cardInput address maxHealthName character.actsOnTurn tabItem

    componentClass =
      inputClasses componentName
  in
    div
      [ componentClass [ "input-group" ] ]
      [ label
          [ componentClass [ "label", "centered-text" ] ]
          [ text "Health" ]
      , div
          [ componentClass [ "health-group" ] ]
          [ currentHealthInput
              [ componentClass [ "current-health", "input" ]
              , placeholder "HP"
              , maxlength 3
              , on
                  "input"
                  targetValue
                  (\value -> Signal.message address (UpdateCurrentHealth character.id (parseInt value)))
              , property "defaultValue" (Json.Encode.string (toString character.currentHealth))
              ]
          , span
              [ componentClass [ "slash" ] ]
              [ text "/" ]
          , maxHealthInput
              [ componentClass [ "max-health", "input" ]
              , placeholder "HP"
              , maxlength 3
              , on
                  "input"
                  targetValue
                  (\value -> Signal.message address (UpdateMaxHealth character.id (parseInt value)))
              , property "defaultValue" (Json.Encode.string (toString character.maxHealth))
              ]
          ]
      ]


changeHealthInput : Address Action -> String -> String -> Character -> Html
changeHealthInput address tabItem componentName character =
  let
    inputName =
      "ChangeHealth"

    healOrHarmAmount =
      character.currentHealth + (parseInt character.changeHealth)

    changeHealthInput =
      cardInput address inputName character.actsOnTurn tabItem

    componentClass =
      inputClasses componentName
  in
    div
      [ componentClass [ "input-group" ] ]
      [ label
          [ componentClass [ "label", "centered-text" ] ]
          [ text "Heal/Harm" ]
      , changeHealthInput
          [ componentClass [ "change-health", "input", "centered-text" ]
          , placeholder "0"
          , type' "number"
          , onInput address (UpdateChangeHealth character.id)
          , onEnter address (HealOrHarmCharacter character.id healOrHarmAmount)
          , property "defaultValue" (Json.Encode.string character.changeHealth)
          ]
      ]



-- UTILS


cardInput : Address Action -> String -> Int -> String -> List Attribute -> Html
cardInput address fieldName actsOnTurn tabindex additionalAttributes =
  let
    tabBetween =
      assignTabIndex fieldName tabindex

    defaultAttributes =
      [ id (fieldName ++ toString actsOnTurn)
      , spellcheck False
      , name fieldName
      , onClick address (SetTabIndex fieldName)
      ]
        |> List.append tabBetween
        |> List.append additionalAttributes
  in
    input
      defaultAttributes
      []



-- inputClasses : Allow common input components to have different component styles across the app.


inputClasses : String -> List String -> Attribute
inputClasses componentName classes =
  classes
    |> List.map (\word -> componentName ++ word)
    |> List.intersperse (" ")
    |> List.foldr (++) ""
    |> class



-- Enter focus mode: When clicking on an input, tab will take you through each character.


assignTabIndex : String -> String -> List Html.Attribute
assignTabIndex tabItem inputType =
  if (tabItem == inputType || tabItem == "") then
    []
  else
    [ tabindex -1 ]
