module Test.Main where

import Prelude hiding (unless,when)

import CallByName.Alt ((<|>))
import CallByName.Applicative (unless, when)
import CallByName.Monoid (guard)
import CallByName.Syntax ((~))
import Data.Either (Either(..))
import Data.Lazy (Lazy, force)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception.Unsafe (unsafeThrow)
import Effect.Ref as Ref
import Effect.Unsafe (unsafePerformEffect)

forceTwice :: forall a. Lazy a -> a
forceTwice a =
  let _ = force a
  in force a

main :: Effect Unit
main = do
  ref <- Ref.new false
  let
    lazyTest =
      forceTwice ~(unsafePerformEffect do
        val <- Ref.read ref
        if val
          then unsafeThrow "Not lazy!"
          else Ref.write true ref)

    altTest1 =
      Just unit <|> unsafeThrow "Too strict!"

    altTest2 =
      Right unit <|> unsafeThrow "Too strict!"

  when false \_ ->
    unsafeThrow "Too strict!"

  unless true \_ ->
    unsafeThrow "Too strict!"

  guard false \_ ->
    unsafeThrow "Too strict!"
