module Update (..) where

import Effects exposing (Effects, Never)
import String
import Char exposing (isDigit)


-- import Task exposing (Task, andThen)

import Model exposing (..)


type Action
  = NoOp
  | UpdateName Int String
  | UpdateInit Int String
  | UpdateCurrentHealth Int Int
  | UpdateMaxHealth Int Int
  | UpdateChangeHealth Int String
  | HoldAction Int Int
  | ResumeAction Int String
  | AddCharacter
  | RemoveCharacter Int Int
  | CopyCharacter Character
  | ActivateCharacter Int Int
  | HealOrHarmCharacter Int Int
  | SetTabIndex String
  | SortCharacters
  | AdvanceRound
  | ReverseRound


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    NoOp ->
      ( model, Effects.none )

    UpdateName id newName ->
      let
        updateCharacter character =
          if character.id == id then
            { character
              | name = newName
            }
          else
            character

        newCharacterList =
          model.characters
            |> List.map updateCharacter
      in
        ( { model
            | characters = newCharacterList
          }
        , Effects.none
        )

    UpdateInit id newInit ->
      let
        updateCharacter character =
          if character.id == id then
            { character
              | initiative = newInit
            }
          else
            character

        newCharacterList =
          model.characters
            |> List.map updateCharacter
      in
        ( { model
            | characters = newCharacterList
            , remindToSort = True
          }
        , Effects.none
        )

    UpdateCurrentHealth id newHealth ->
      let
        updateCharacter character =
          if character.id == id then
            { character
              | currentHealth = newHealth
            }
          else
            character

        newCharacterList =
          model.characters
            |> List.map updateCharacter
      in
        ( { model
            | characters = newCharacterList
          }
        , Effects.none
        )

    UpdateMaxHealth id newHealth ->
      let
        updateCharacter character =
          if character.id == id then
            { character
              | maxHealth = newHealth
            }
          else
            character

        newCharacterList =
          model.characters
            |> List.map updateCharacter
      in
        ( { model
            | characters = newCharacterList
          }
        , Effects.none
        )

    UpdateChangeHealth id newHealth ->
      let
        updateCharacter character =
          if character.id == id then
            { character
              | changeHealth = newHealth
            }
          else
            character

        newCharacterList =
          model.characters
            |> List.map updateCharacter
      in
        ( { model
            | characters = newCharacterList
          }
        , Effects.none
        )

    HealOrHarmCharacter id newHealth ->
      let
        updateCharacter character =
          if character.id == id then
            { character
              | changeHealth = ""
              , currentHealth = newHealth
            }
          else
            character

        newCharacterList =
          model.characters
            |> List.map updateCharacter
      in
        ( { model
            | characters = newCharacterList
          }
        , Effects.none
        )

    AddCharacter ->
      let
        newCharacter =
          { emptyCharacter
            | id = model.nextId
            , active = List.isEmpty model.characters
            , actsOnTurn = List.length model.characters + 1
          }

        newCharacterList =
          model.characters ++ [ newCharacter ]
      in
        ( { model
            | characters = newCharacterList
            , nextId = model.nextId + 1
            , turnsPerRound = List.length newCharacterList
          }
        , Effects.none
        )

    RemoveCharacter id turn ->
      let
        newTurn =
          if turn <= model.turn then
            atLeastOne (turn - 1)
          else if model.turn == model.turnsPerRound then
            atLeastOne (model.turn - 1)
          else
            model.turn

        newCharacterList =
          model.characters
            |> List.filter (\c -> c.id /= id)
            |> sortCharacters
            |> List.map (setActiveTurn newTurn)
      in
        ( { model
            | characters = newCharacterList
            , turnsPerRound = List.length newCharacterList
            , turn = newTurn
          }
        , Effects.none
        )

    SortCharacters ->
      let
        sortedCharacters =
          sortCharacters model.characters
      in
        ( { model
            | characters = sortedCharacters
            , remindToSort = False
          }
        , Effects.none
        )

    ActivateCharacter id actsOnTurn ->
      let
        newCharacterList =
          model.characters
            |> List.map (setActiveTurn actsOnTurn)
      in
        ( { model
            | characters = newCharacterList
            , turn = actsOnTurn
          }
        , Effects.none
        )

    CopyCharacter character ->
      let
        newCharacter =
          { character
            | active = False
            , id = model.nextId
          }

        newCharacterList =
          [ newCharacter ]
            ++ model.characters
            |> sortCharacters
            |> List.map (setActiveTurn model.turn)
      in
        ( { model
            | characters = newCharacterList
            , nextId = model.nextId + 1
            , turnsPerRound = List.length newCharacterList
            , remindToSort = False
          }
        , Effects.none
        )

    HoldAction id actsOnTurn ->
      let
        updateCharacter character =
          if character.id == id then
            { character
              | holding = True
            }
          else
            character

        newTurn =
          if actsOnTurn == model.turn then
            model.turn + 1
          else
            model.turn

        newRound =
          if model.turn + 1 > model.turnsPerRound then
            model.round + 1
          else
            model.round

        newCharacterList =
          model.characters
            |> List.map updateCharacter
            |> List.map (setActiveTurn newTurn)
      in
        ( { model
            | characters = newCharacterList
            , turn = newTurn
            , round = newRound
          }
        , Effects.none
        )

    ResumeAction id init ->
      let
        activeCharacter =
          findActiveCharacter model.characters

        newInit =
          if init == activeCharacter.initiative then
            init
          else
            activeCharacter.initiative ++ "+"

        updateCharacter character =
          if character.id == id then
            { character
              | holding = False
              , initiative = newInit
            }
          else
            character

        newCharacterList =
          model.characters
            |> List.map updateCharacter
            |> sortCharacters
            |> List.map (setActiveTurn model.turn)
      in
        ( { model
            | characters = newCharacterList
            , remindToSort = False
          }
        , Effects.none
        )

    AdvanceRound ->
      let
        incrementRound =
          model.turn + 1 > model.turnsPerRound

        newTurn =
          if incrementRound then
            1
          else
            model.turn + 1

        newRound =
          if incrementRound then
            model.round + 1
          else
            model.round

        newCharacterList =
          model.characters
            |> List.map (setActiveTurn newTurn)
      in
        ( { model
            | characters = newCharacterList
            , round = newRound
            , turn = newTurn
          }
        , Effects.none
        )

    ReverseRound ->
      let
        decrementRound =
          model.turn == 1

        newRound =
          if decrementRound && model.round == 1 then
            1
          else if decrementRound && model.round > 1 then
            model.round - 1
          else
            model.round

        newTurn =
          if decrementRound && model.round == 1 then
            1
          else if decrementRound && model.round > 1 then
            model.turnsPerRound
          else
            atLeastOne (model.turn - 1)

        newCharacterList =
          model.characters
            |> List.map (setActiveTurn newTurn)
      in
        ( { model
            | characters = newCharacterList
            , turn = newTurn
            , round = newRound
          }
        , Effects.none
        )

    SetTabIndex inputName ->
      ( { model
          | tabItem = inputName
        }
      , Effects.none
      )


setActiveTurn : Int -> Character -> Character
setActiveTurn turn character =
  if character.actsOnTurn == turn then
    { character | active = True }
  else
    { character | active = False }


findActiveCharacter : List Character -> Character
findActiveCharacter characters =
  case characters of
    [] ->
      emptyCharacter

    [ c ] ->
      c

    c :: cs ->
      if c.active then
        c
      else
        findActiveCharacter cs


atLeastOne : Int -> Int
atLeastOne number =
  if number < 1 then
    1
  else
    number


resetAtMax : Int -> Int -> Int
resetAtMax number maxNumber =
  if number > maxNumber then
    1
  else
    number



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



-- Sorts characters, then updates the turn order property.


sortCharacters : List Character -> List Character
sortCharacters characters =
  characters
    |> List.sortWith sortInitiative
    |> List.indexedMap assignTurnOrder



-- Used with indexedMap to assign turn order based on a sorted list.


assignTurnOrder : Int -> Character -> Character
assignTurnOrder turn character =
  { character
    | actsOnTurn = turn + 1
  }



{-
  I can't tell if the below methods are terrible, or super terrible.

  In D&D and Pathfinder, you roll for initiative. In the case of a tie, you
  compare base scores, or roll again. Eventually order is determined.

  However, the initative score is still the same. Typically this results in a
  list of initiatives with values like 16++, 16+, 16, 14, 12, where + indicates
  that this person won the tie.

  I've kept initiative a string, so the user can easily denote order this way.
  However, simply sorting by string doesn't get the right results. We need to
  parse the value.

  For each initative, we reduce each value to just the digits. Then we try to
  parse that score as an integer.

  We sort by the initiative score, taking the larger number. On a tie, we sort
  by the length of the initial value altogether.
-}


sortInitiative : Character -> Character -> Order
sortInitiative a b =
  let
    -- Get all the information from initiative A
    initA =
      a.initiative

    digitsInA =
      getDigits initA

    lengthInitA =
      String.length initA

    -- Get all the information from initiative B
    initB =
      b.initiative

    digitsInB =
      getDigits initB

    lengthInitB =
      String.length initB

    tieBreaker =
      higherFirst lengthInitA lengthInitB EQ
  in
    higherFirst digitsInA digitsInB tieBreaker


higherFirst : comparable -> comparable -> Order -> Order
higherFirst firstItem secondItem tieBreaker =
  case compare firstItem secondItem of
    LT ->
      GT

    EQ ->
      tieBreaker

    GT ->
      LT


getDigits : String -> Int
getDigits string =
  parseInt (String.filter isDigit string)


parseInt : String -> Int
parseInt string =
  case String.toInt string of
    Ok value ->
      value

    Err error ->
      0
