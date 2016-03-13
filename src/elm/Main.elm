module Main (..) where

import StartApp
import Signal exposing (Signal, Address)
import Html exposing (..)
import Html.Attributes exposing (..)
import Effects exposing (Effects, Never)
import Task exposing (Task)


-- My modules

import CharacterList
import MenuBar
import Update exposing (..)
import Model exposing (..)


-- UPDATE
-- VIEW


view : Address Action -> Model -> Html
view address model =
  div
    [ class "container" ]
    [ MenuBar.view address model
    , CharacterList.view address model
    ]



-- this type annoation is dumb


app : StartApp.App Model
app =
  StartApp.start
    { init = ( initialModel, Effects.none )
    , view = view
    , update = update
    , inputs = []
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
