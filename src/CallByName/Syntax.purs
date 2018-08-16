module CallByName.Syntax where

import Prelude

import CallByName.Class (CBN)
import Data.Lazy (Lazy)
import Data.Lazy as Lazy
import Unsafe.Coerce (unsafeCoerce)

defer :: forall a. CBN a -> Unit -> a
defer = unsafeCoerce

deferApply :: forall a b. ((Unit -> a) -> b) -> CBN a -> b
deferApply = unsafeCoerce

infixl 10 deferApply as \

lazy :: forall a. CBN a -> Lazy a
lazy = unsafeCoerce Lazy.defer

lazyApply :: forall a b. (Lazy a -> b) -> CBN a -> b
lazyApply f = unsafeCoerce (f <<< Lazy.defer)

infixl 10 lazyApply as ~
