import StartApp.Simple as StartApp
import Html exposing (..)
import Html.Attributes exposing (..)

-- MODEL
model : number
model = 0


-- UPDATE
update: a -> a
update model =
  model


-- VIEW
view : a -> b -> Html
view address model =
  div []
    [ span [] [ text "Everything looks good! Go start changing some files."] ]



-- START APP
main: Signal Html
main =
  StartApp.start
    { model = model
    , update = update
    , view = view
    }
