module EB.AppM where

import Prelude

import EB.Capability.LogMessages (class LogMessages)
import EB.Capability.Navigate (class Navigate)
import EB.Capability.Now (class Now)
import EB.Data.Log as Log
import EB.Data.Route as Route
import EB.Store (Action, EnvironmentType(..), Store)
import EB.Store as Store
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Console as Console
import Effect.Now as Now
import Foreign (unsafeToForeign)
import Halogen as H
import Halogen.Store.Monad (class MonadStore, StoreT, getStore, runStoreT)
import Routing.Duplex (print)
import Safe.Coerce (coerce)

newtype AppM a = AppM (StoreT Store.Action Store.Store Aff a)

runAppM :: forall q i o. Store.Store -> H.Component q i o AppM -> Aff (H.Component q i o Aff)
runAppM store = runStoreT store Store.reduce <<< coerce

derive newtype instance functorAppM :: Functor AppM
derive newtype instance applyAppM :: Apply AppM
derive newtype instance applicativeAppM :: Applicative AppM
derive newtype instance bindAppM :: Bind AppM
derive newtype instance monadAppM :: Monad AppM
derive newtype instance monadEffectAppM :: MonadEffect AppM
derive newtype instance monadAffAppM :: MonadAff AppM
derive newtype instance monadStoreAppM :: MonadStore Action Store AppM

instance nowAppM :: Now AppM where
  now = liftEffect Now.now
  nowDate = liftEffect Now.nowDate
  nowTime = liftEffect Now.nowTime
  nowDateTime = liftEffect Now.nowDateTime

instance logMessagesAppM :: LogMessages AppM where
  logMessage log = do
    { envType } <- getStore
    liftEffect case envType, Log.level log of
      Prod, Log.Debug -> pure unit
      _, _ -> Console.log $ Log.message log

instance navigateAppM :: Navigate AppM where
  navigate x = do
    { psi } <- getStore
    liftEffect $ psi.pushState (unsafeToForeign unit) $ print Route.routeCodec x