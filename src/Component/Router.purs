module EB.Component.Router where

import Prelude

import Data.Either (hush)
import Data.Maybe (Maybe(..))
import Data.Traversable (sequence)
import EB.Capability.LogMessages (class LogMessages)
import EB.Capability.Navigate (class Navigate, navigate)
import EB.Capability.Now (class Now)
import EB.Data.Route (Route(..), routeCodec)
import EB.Page.Home as Home
import EB.Store as Store
import Effect.Aff.Class (class MonadAff)
import Halogen (liftEffect)
import Halogen as H
import Halogen.HTML as HH
import Halogen.Store.Connect (Connected, connect)
import Halogen.Store.Monad (class MonadStore)
import Halogen.Store.Select (selectEq)
import Routing.Duplex as RD
import Routing.Hash (getHash)
import Type.Proxy (Proxy(..))

data Query a = Navigate Route a
type Input = Unit

type OpaqueSlot slot = forall query. H.Slot query Void slot

type State =
  { route :: Maybe Route
  }
deriveState :: forall a. Connected a Input -> State
deriveState _ = { route: Nothing }


data Action
  = Initialize

type ChildSlots =
  ( home :: OpaqueSlot Unit
  )

component
  :: forall m
   . MonadAff m
  => MonadStore Store.Action Store.Store m
  => Now m
  => LogMessages m
  => Navigate m
  => H.Component Query Input Void m
component = connect (selectEq _.envType) $ H.mkComponent
  { initialState: deriveState
  , render
  , eval: H.mkEval $ H.defaultEval
      { handleQuery = handleQuery
      , handleAction = handleAction
      , initialize = Just Initialize
      }
  }
  where
  handleAction :: Action -> H.HalogenM State Action ChildSlots Void m Unit
  handleAction = case _ of
    Initialize -> do
      -- first we'll get the route the user landed on
      initialRoute <- hush <<< (RD.parse routeCodec) <$> liftEffect getHash
      -- then we'll navigate to the new route (also setting the hash)
      void <<< sequence $ navigate <$> initialRoute
      pure unit


  handleQuery :: forall a. Query a -> H.HalogenM State Action ChildSlots Void m (Maybe a)
  handleQuery = case _ of
    Navigate dest a -> do
      { route } <- H.get
      -- don't re-render unnecessarily if the route is unchanged
      when (route /= Just dest) do
        H.modify_ _ { route = Just dest }
      pure (Just a)

  render :: State -> H.ComponentHTML Action ChildSlots m
  render { route } = case route of
    Just r -> case r of
      Home ->
        HH.slot_ (Proxy :: _ "home") unit Home.component unit
    Nothing ->
      HH.div_ [ HH.text "Oh no! That page wasn't found." ]
