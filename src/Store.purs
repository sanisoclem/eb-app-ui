module EB.Store where

import Prelude

data EnvironmentType = Dev | Prod

derive instance eqEnvironmentType :: Eq EnvironmentType
derive instance ordEnvironmentType :: Ord EnvironmentType

type Store =
  { envType :: EnvironmentType
  }

data Action
  = Noop

reduce :: Store -> Action -> Store
reduce store = case _ of
  Noop ->
    store
