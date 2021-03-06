module Player exposing (Player, init, draw, tick, front)

import Collage exposing (..)
import Color exposing (Color)
import Random exposing (..)
import Vector exposing (..)
import Colors

type alias Player =
  { position : Vector
  , velocity : Vector
  , rotation : Float
  , radius : Float
  , colors : (Color, Color)
  }

init : Int -> Player -> Player
init randomInt player =
  let
    generator = int 0 Colors.max
    (num, _) = step generator (initialSeed randomInt)
  in
    { player
    | colors = Colors.getColor num
    }

tick : Float -> (Float, Float) -> Player -> Player
tick timeDelta mouse player =
  let
    velocity =
      (0, 150 * timeDelta)
        |> Vector.rotate player.rotation
        |> (*>) (distance player.position mouse |> min 100)

    rotation = calcRotation player.position mouse
  in
    { player
    | velocity = velocity
    , rotation = rotation
    }

calcRotation : (Float, Float) -> (Float, Float) -> Float
calcRotation (x, y) (x', y') =
  atan2 (x' - x) (y' - y)

draw : Player ->  Form
draw player =
  let
    shape = circle player.radius
    outline =
      { defaultLine
      | color = snd player.colors
      , width = 7
      , cap = Round
      , join = Smooth
      }
  in
    [ shape
    |> filled (fst player.colors)
    , shape
    |> outlined outline
    ]
      |> group

front : Vector -> Float -> Float -> Vector
front position rotation radius =
  position <+> Vector.rotate rotation (0, radius * 1.5)
