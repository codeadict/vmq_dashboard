module VMQDashboard exposing (..)

import StartApp
import Window
import Html

import Navigation
import Route


app : StartApp.App Model

main : Signal Html.Html
main =
  app.html