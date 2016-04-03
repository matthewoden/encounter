module Utils.Input (onEnter, onInput) where

import Update exposing (Action)
import Signal exposing (Signal, Address)
import Html exposing (Attribute)
import Html.Events exposing (on, keyCode, targetValue)
import Json.Decode as Json


-- Handle Enter as Submit


onEnter : Address Action -> Action -> Attribute
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


onInput : Address Action -> (String -> Action) -> Attribute
onInput address action =
  on "input" targetValue (\v -> Signal.message address (action v))
