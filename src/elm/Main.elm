import StartApp.Simple as StartApp
import Signal exposing (Signal, Address)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, targetValue)
import Icons

-- MODEL

-- Eventually a list of encounters.
type alias Model =
  { characters : List Character
  , nextId : Int
  , turn : Int
  , round : Int
  , past : List History
  , future: List History
  }


type alias History =
  { turn : Int
  , round : Int
  , characters : List Character
  }

type alias Character =
  { id : Int
  , active : Bool
  , previouslyActive: Bool
  , name : String
  , initiative : String
  , currentHealth : Int
  , maxHealth : Int
  , notes: String
  }


initialModel : Model
initialModel =
  { characters = [ initialCharacter ]
  , nextId = 1
  , turn = 0
  , round = 0
  , past = []
  , future = []
  }


initialCharacter : Character
initialCharacter =
  { id = 0
  , active = False
  , previouslyActive = False
  , name = ""
  , initiative = ""
  , currentHealth = 0
  , maxHealth = 0
  , notes = ""
  }


-- UPDATE

type Action
  = NoOp
  | UpdateName Int String
  | UpdateInit Int String
  | AddCharacter
  | RemoveCharacter Int
  | ActivateCharacter Int
  | SortCharacters
  | AdvanceRound



update: Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model

    UpdateName id newName ->
      let
        updateCharacter character =
          if character.id == id then
            { character | name = newName }
          else
            character
      in
        { model |
          characters = List.map updateCharacter model.characters
        }

    UpdateInit id newInit ->
      let
        updateCharacter c =
          if c.id == id then { c | initiative = newInit } else c
      in
        { model |
          characters = List.map updateCharacter model.characters
        }

    AddCharacter ->
      let
        newCharacter = { initialCharacter | id = model.nextId }
        newCharacterList = model.characters ++ [newCharacter]
      in
        { model |
          characters = newCharacterList
        , nextId = model.nextId + 1
        }

    RemoveCharacter id ->
      let
        newCharacterList = List.filter (\c -> c.id /= id ) model.characters
      in
        { model |
          characters = newCharacterList
        , past = [createRoundHistory model] ++ model.past
        }

    SortCharacters ->
      let
        sortedCharacters = List.sortWith sortInitative model.characters
      in
        { model | characters = sortedCharacters}

    ActivateCharacter id ->
      let
        newCharacters = setActiveInit id model.characters
      in
        { model |
          characters = newCharacters
        , turn = id
        , past = [createRoundHistory model] ++ model.past
        }

    AdvanceRound ->
      let
          newCharacterList = model.characters

      in
        { model |
          characters = model.characters
        , turn = 0
        , past = [createRoundHistory model] ++ model.past
        }


setActiveInit : Int -> List Character -> List Character
setActiveInit id characters =
  let
    activateCharacter c =
      if c.id == id then
        { c | active = True }
      else
        { c | active = False }
  in
    List.map activateCharacter characters

-- findNextInit model characters =
{-
  findNextInit needs to recursively move through the character list and check if
  a character is active.

  When the active character is found, do one of the following:
  1. If there are more characters (the list tail) set the head of the tail to be
     active.

  2. If there are no more characters, set the head of the original list to be
     active. The round should increment by one.

  Either way, the turn should be set this character's id.

  This should probably return a history record.

 -}

{-
 Creates a new round history record from the current model.
 Allows for the restoration of characters and turn order.
-}
createRoundHistory : Model -> History
createRoundHistory model =
    { turn = model.turn
    , round = model.round
    , characters = model.characters
    }

{-
 sortInitative is used with a list of characters, and sortWith. To replicate play
 order, it must be a decending list of initiative scores. Most of the time we're
 sorting by number, but initative is to be kept a string.

 This allows for easily read notation like 16, 16+ and 16+++ for initative ties.

 I stole the compare code wholesale from the List.sortWith example.
-}
sortInitative: Character -> Character -> Order
sortInitative a b =
  let
    initA = a.initiative
    initB = b.initiative
  in
    case compare initA initB of
        LT -> GT
        EQ -> EQ
        GT -> LT


-- VIEW

view : Address Action -> Model -> Html
view address model =
  let
    characters = model.characters
  in
  div
    [ class "container" ]
    [ div
      [ class "control-bar" ]
      [ div
          [ class "control-bar__status" ]
          [ span
              [ class "control-bar__label"]
              [ text "Round"]
          , span
              [ class "control-bar__value"]
              [ text (toString model.round) ]
            ]
        , div
            [ class "control-bar__status" ]
            [ span
                [ class "control-bar__label"]
                [ text "Turn"]
            , span
                [ class "control-bar__value"]
                [ text (toString model.turn) ]
              ]
          ]
    , controlBar address
    , section
        [ class "character-list" ]
        (List.map (characterListItem address) characters)
    ]


controlBar : Address Action -> Html
controlBar address =
  section
    [ class "control-bar" ]
    [ button
        [ class "control-bar__button"
        , onClick address SortCharacters
        ]
        [ Icons.back ]
    , button
        [ class "control-bar__button"
        , onClick address AddCharacter
        ]
        [ Icons.sword ]
    , button
        [ class "control-bar__button"
        , onClick address SortCharacters
        ]
        [ Icons.sort ]
    , button
        [ class "control-bar__button"
        , onClick address SortCharacters
        ]
        [ Icons.forward]
    ]


characterListItem : Address Action -> Character -> Html
characterListItem address character =
  div
    [ classList
        [ ("character", True)
        , ("character--active", character.active)
        ]
    ]
    [ button
      [ class "character__activate"
      , onClick address (ActivateCharacter character.id)
      ]
      [ Icons.crown character.active ]
    , input
        [ id "Init"
        , class "character__initiative"
        , placeholder "Init"
        , name "Init"
        , on "input" targetValue
            (Signal.message address << UpdateInit character.id)
        , maxlength 3
        , value character.initiative
        ]
        []
    , input
        [ id "Name"
        , class "character__name"
        , placeholder "Name (Click to edit)"
        , name "Name"
        , on "input" targetValue
            (Signal.message address << UpdateName character.id)
        , value character.name
        ]
        []
    , button
        [ class "character__remove"
        , onClick address (RemoveCharacter character.id)
        ]
        [ Icons.close character.active ]

    ]

-- START APP
main : Signal Html
main =
  StartApp.start
    { model = initialModel
    , update = update
    , view = view
    }
