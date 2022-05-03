module CallByName.Applicative where

import Prelude

when :: forall m. Applicative m => Boolean -> (Unit -> m Unit) -> m Unit
when true k = k unit
when _ _ = pure unit

unless :: forall m. Applicative m => Boolean -> (Unit -> m Unit) -> m Unit
unless false k = k unit
unless _ _ = pure unit
