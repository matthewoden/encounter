module CharacterList (..) where

import Signal exposing (Signal, Address)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, targetValue, keyCode)
import Json.Decode as Json


-- My modules

import Icons
import Model exposing (..)
import Update exposing (..)


view : Address Action -> Model -> Html
view address model =
  div
    [ class "sidebar" ]
    [ model.characters
        |> List.map (card address model.tabItem)
        |> section [ class "sidebar__list" ]
    ]


card : Address Action -> String -> Character -> Html
card address tabItem character =
  div
    [ classList
        [ ( "character", True )
        , ( "character--active", character.active )
        , ( "character--holding", character.holding )
        ]
    ]
    [ div
        [ class "character__status" ]
        [ nameInput address tabItem character
        , div
            [ class "character__input-row" ]
            [ initiativeInput address tabItem character
            , healthInput address tabItem character
            , changeHealthInput address tabItem character
            ]
        ]
    , characterControls address character
    ]



{-
The name field for a character
-}


nameInput : Address Action -> String -> Character -> Html
nameInput address tabItem character =
  let
    inputName =
      "Name"

    nameInput =
      cardInput address inputName character.id tabItem
  in
    div
      [ class "character__input-group" ]
      [ label
          [ class "character__label" ]
          [ text "name" ]
      , nameInput
          [ class "character__name character__input"
          , placeholder "Name (Click to edit)"
          , on
              "input"
              targetValue
              (Signal.message address << UpdateName character.id)
          , value character.name
          ]
      ]


initiativeInput : Address Action -> String -> Character -> Html
initiativeInput address tabItem character =
  let
    inputName =
      "Initiative"

    initiativeInput =
      cardInput address inputName character.id tabItem
  in
    div
      [ class "character__input-group" ]
      [ label
          [ class "character__label character__centered-text" ]
          [ text "Initiative" ]
      , initiativeInput
          [ class "character__initiative character__input"
          , placeholder "0"
          , on
              "input"
              targetValue
              (Signal.message address << UpdateInit character.id)
          , onEnter address SortCharacters
          , maxlength 5
          , value character.initiative
          ]
      ]


healthInput : Address Action -> String -> Character -> Html
healthInput address tabItem character =
  let
    currentHealthName =
      "CurrentHealth"

    maxHealthName =
      "MaxHealth"

    currentHealthInput =
      cardInput address currentHealthName character.id tabItem

    maxHealthInput =
      cardInput address maxHealthName character.id tabItem
  in
    div
      [ class "character__input-group" ]
      [ label
          [ class "character__label character__centered-text" ]
          [ text "Health" ]
      , div
          [ class "character__health-group" ]
          [ currentHealthInput
              [ class "character__current-health character__input"
              , placeholder "HP"
              , maxlength 3
              , on
                  "input"
                  targetValue
                  (\value -> Signal.message address (UpdateCurrentHealth character.id (parseInt value)))
              , value (toString character.currentHealth)
              ]
          , span
              [ class "character__slash" ]
              [ text "/" ]
          , maxHealthInput
              [ class "character__max-health character__input"
              , placeholder "HP"
              , maxlength 3
              , on
                  "input"
                  targetValue
                  (\value -> Signal.message address (UpdateMaxHealth character.id (parseInt value)))
              , value (toString character.maxHealth)
              ]
          ]
      ]


changeHealthInput : Address Action -> String -> Character -> Html
changeHealthInput address tabItem character =
  let
    inputName =
      "ChangeHealth"

    healOrHarmAmount =
      character.currentHealth + (parseInt character.changeHealth)

    changeHealthInput =
      cardInput address inputName character.id tabItem
  in
    div
      [ class "character__input-group" ]
      [ label
          [ class "character__label character__centered-text" ]
          [ text "Heal/Harm" ]
      , changeHealthInput
          [ class "character__change-health character__input character__centered-text"
          , placeholder "0"
          , type' "number"
          , on "input" targetValue (Signal.message address << UpdateChangeHealth character.id)
          , onEnter
              address
              (HealOrHarmCharacter character.id healOrHarmAmount)
          , value character.changeHealth
          ]
      ]



{-
The control bar for this character. This is where a user can Activate, Hold,
Copy, or Remove a character.
TODO: make this a little more modular.
-}


characterControls : Address Action -> Character -> Html
characterControls address character =
  let
    holdAction =
      if character.holding == False then
        (HoldAction character.id character.actsOnTurn)
      else
        (ResumeAction character.id character.initiative)
  in
    div
      [ class "character__action-bar" ]
      [ div
          [ class "character__action"
          , onClick address (ActivateCharacter character.id character.actsOnTurn)
          ]
          [ Icons.crown character.active
          , text "Turn"
          ]
      , div
          [ class "character__action"
          , onClick address holdAction
          ]
          [ Icons.hold character.active
          , text "Hold"
          ]
      , div
          [ class "character__action"
          , onClick address (CopyCharacter character)
          ]
          [ Icons.copy character.active
          , text "Copy"
          ]
      , div
          [ class "character__action"
          , onClick address (RemoveCharacter character.id character.actsOnTurn)
          ]
          [ Icons.close character.active
          , text "Remove"
          ]
      ]



-- UTILS


cardInput : Address Action -> String -> Int -> String -> List Attribute -> Html
cardInput address fieldName characterId tabindex additionalAttributes =
  let
    tabBetween =
      assignTabIndex fieldName tabindex

    defaultAttributes =
      [ id (fieldName ++ toString characterId)
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


assignTabIndex : String -> String -> List Html.Attribute
assignTabIndex tabItem inputType =
  if (tabItem == inputType || tabItem == "") then
    []
  else
    [ tabindex -1 ]


onEnter : Address a -> a -> Attribute
onEnter address value =
  on
    "keydown"
    (Json.customDecoder keyCode is13)
    (\_ -> Signal.message address value)


is13 : Int -> Result String ()
is13 code =
  if code == 13 then
    Ok ()
  else
    Err "not the right key code"
