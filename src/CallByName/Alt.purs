module CallByName.Alt where

import Prelude

import CallByName.Class (CBN)
import Control.Alt as Strict
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Unsafe.Coerce (unsafeCoerce)

class Strict.Alt f <= Alt f where
  alt :: forall a. f a -> (Unit -> f a) -> f a

cbnAlt :: forall f a. Alt f => f a -> CBN (f a) -> f a
cbnAlt = unsafeCoerce (alt :: f a -> (Unit -> f a) -> f a)

infixr 3 cbnAlt as <|>

instance altMaybe :: Alt Maybe where
  alt a k = case a of
    Just _ -> a
    Nothing -> k unit

instance altEither :: Alt (Either e) where
  alt a k = case a of
    Right _ -> a
    Left _ -> k unit
