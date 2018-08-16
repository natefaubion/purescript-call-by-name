module CallByName.Class where

class CallByName a
instance cbn :: CallByName a

type CBN a = CallByName a => a
