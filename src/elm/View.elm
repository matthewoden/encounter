module View (..) where

import Signal exposing (Address)
import Html exposing (..)
import Html.Attributes exposing (..)


-- import Debug
-- My modules

import CharacterCards.View as CharacterCards
import MenuBar.MenuBar as MenuBar
import CharacterSheet.CharacterSheet as CharacterSheet
import Update exposing (..)
import Model exposing (..)
import Html.Lazy exposing (lazy2)


-- import Login.Login as Login


view : Address Action -> Model -> Html
view address model =
  div
    [ class "container" ]
    [ lazy2 MenuBar.view address model
    , div
        [ class "encounter-view" ]
        [ lazy2 CharacterCards.view address model
        , lazy2 CharacterSheet.view address model
        ]
    ]
