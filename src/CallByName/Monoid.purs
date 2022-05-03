module CallByName.Monoid where

import Prelude

guard :: forall m. Monoid m => Boolean -> (Unit -> m) -> m
guard true k = k unit
guard _ _ = mempty
