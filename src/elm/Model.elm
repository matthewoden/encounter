module Model (..) where


type alias Model =
  { characters : List Character
  , nextId : Int
  , turn : Int
  , turnsPerRound : Int
  , round : Int
  , remindToSort : Bool
  , tabItem : String
  , isLastInput : Bool
  }


type alias History =
  { turn : Int
  , round : Int
  , characters : List Character
  }


type alias Character =
  { id : Int
  , active : Bool
  , selected : Bool
  , holding : Bool
  , notes : String
  , name : String
  , initiative : String
  , actsOnTurn : Int
  , currentHealth : Int
  , changeHealth : String
  , maxHealth : Int
  }


initialCharacter : Character
initialCharacter =
  { id = 0
  , active = True
  , selected = True
  , holding = False
  , notes = ""
  , name = ""
  , initiative = ""
  , actsOnTurn = 1
  , currentHealth = 0
  , changeHealth = ""
  , maxHealth = 0
  }


emptyCharacter : Character
emptyCharacter =
  { id = 0
  , active = False
  , selected = False
  , holding = False
  , notes = ""
  , name = ""
  , initiative = ""
  , actsOnTurn = 0
  , currentHealth = 0
  , changeHealth = ""
  , maxHealth = 0
  }


emptyModel : Model
emptyModel =
  { characters = []
  , nextId = 1
  , turn = 1
  , turnsPerRound = 1
  , round = 1
  , remindToSort = False
  , tabItem = ""
  , isLastInput = False
  }
