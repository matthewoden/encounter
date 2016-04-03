module Login.Mailbox (..) where

import Signal
import Signal exposing (Mailbox, Address, mailbox)


type Action
  = NoOp
  | Login
  | Logout


loginMailbox : Signal.Mailbox Action
loginMailbox =
  Signal.mailbox NoOp
