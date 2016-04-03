module Main (..) where

import StartApp
import Signal exposing (Signal, Address)
import Html exposing (..)
import Effects exposing (Effects, Never)
import Task exposing (Task)


-- import ScratchPad.Input exposing (..)
-- import Debug
-- My modules

import Update exposing (..)
import Model exposing (..)
import View exposing (view)
import KeyboardShortcuts exposing (..)


app : StartApp.App Model
app =
  StartApp.start
    { init = ( initialModel, Effects.none )
    , view = view
    , update = update
    , inputs = [ directionalShortcuts, statusShortcuts ]
    }


main : Signal Html
main =
  app.html


initialModel : Model
initialModel =
  Maybe.withDefault emptyModel getStorage



-- Elm effects


port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks



-- Incoming Model


port getStorage : Maybe Model



-- Outgoing Model


port setStorage : Signal Model
port setStorage =
  app.model



-- port getTextareaHeight : Signal String
-- port getTextareaHeight =
--   let
--     toSelector action =
--       case action of
--         Resize selector _ ->
--           selector
--
--         _ ->
--           ""
--   in
--     textareaMailbox.signal
--       |> Signal.map toSelector
