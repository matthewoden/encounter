module Model (..) where


type alias Model =
  { characters : List Character
  , nextId : Int
  , turn : Int
  , turnsPerRound : Int
  , activeCharacter : Character
  , round : Int
  , remindToSort : Bool
  , tabItem : String
  }


type alias History =
  { turn : Int
  , round : Int
  , characters : List Character
  }


type alias Character =
  { id : Int
  , active : Bool
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
  { characters = [ initialCharacter ]
  , nextId = 1
  , turn = 1
  , turnsPerRound = 1
  , activeCharacter = initialCharacter
  , round = 1
  , remindToSort = False
  , tabItem = ""
  }
