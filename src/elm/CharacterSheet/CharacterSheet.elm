module CharacterSheet.CharacterSheet (..) where

import Signal exposing (Address)
import Html exposing (..)
import Html.Attributes exposing (..)


-- My modules

import Update exposing (..)
import Model exposing (..)
import Inputs.Inputs exposing (nameInput, initiativeInput, healthInput, changeHealthInput, notes)


view : Address Action -> Model -> Html
view address model =
  section
    [ class "sheet-list" ]
    (List.map (characterSheet address) model.characters)


characterSheet : Address Action -> Character -> Html
characterSheet address character =
  section
    [ classList
        [ ( "sheet", True )
        , ( "sheet--selected", character.selected )
        ]
    ]
    [ summary address character
    , notes address character
    ]


summary : Address Action -> Character -> Html
summary address character =
  let
    componentClass =
      "summary__"
  in
    div
      [ class "summary" ]
      [ nameInput address "" componentClass character
      , div
          [ class "summary__input-row" ]
          [ initiativeInput address "" componentClass character
          , healthInput address "" componentClass character
          , changeHealthInput address "" componentClass character
          ]
      ]
