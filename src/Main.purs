module Main where

import Prelude

import EB.AppM (runAppM)
import EB.Component.Router as Router
import EB.Data.Route (routeCodec)
import EB.Store (EnvironmentType(..), Store)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Halogen (liftEffect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)
import Routing.Duplex (parse)
import Routing.Hash (matchesWith)

main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  let envType = Dev

  let
    initialStore :: Store
    initialStore = { envType }

  rootComponent <- runAppM initialStore Router.component

  halogenIO <- runUI rootComponent unit body

  void $ liftEffect $ matchesWith (parse routeCodec) \old new ->
    when (old /= Just new) $ launchAff_ do
      _response <- halogenIO.query $ H.mkTell $ Router.Navigate new
      pure unit
