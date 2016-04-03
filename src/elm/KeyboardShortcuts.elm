module KeyboardShortcuts (..) where

import Keyboard exposing (arrows, ctrl)
import Signal exposing (Signal)
import Update exposing (..)


arrowPresses : Signal Action
arrowPresses =
  Signal.map arrowControls Keyboard.arrows


arrowControls : { x : Int, y : Int } -> Action
arrowControls { x, y } =
  case x of
    -1 ->
      ReverseRound

    1 ->
      AdvanceRound

    _ ->
      NoOp


directionalShortcuts : Signal Action
directionalShortcuts =
  Signal.map2 mapArrowsAndCtrl Keyboard.arrows Keyboard.ctrl


statusShortcuts : Signal Action
statusShortcuts =
  Signal.map2 mapPressesAndCtrl Keyboard.presses Keyboard.ctrl


mapPressesAndCtrl : Int -> Bool -> Action
mapPressesAndCtrl keyCode ctrlIsPressed =
  if ctrlIsPressed then
    case keyCode of
      8 ->
        HoldActiveCharacter

      -- 'd' ->
      -- Copy Current Character
      14 ->
        AddCharacter

      _ ->
        NoOp
  else
    NoOp


mapArrowsAndCtrl : { x : Int, y : Int } -> Bool -> Action
mapArrowsAndCtrl { x, y } ctrlIsPressed =
  if x == 1 && ctrlIsPressed then
    AdvanceRound
  else if x == -1 && ctrlIsPressed then
    ReverseRound
  else
    NoOp
