module Login.Login (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, targetValue, keyCode, onFocus)


view =
  div
    [ class "login" ]
    [ facebookLoginButton
    ]


facebookLoginButton =
  button
    [ class "facebook-button"
    ]
    [ text "login with facebook" ]
