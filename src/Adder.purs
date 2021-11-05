module Adder where

import Prelude
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP

data Mode 
  = Start
  | Adding

type State = { keys :: Array String, mode :: Mode }


type KeyValue = { key :: String, value :: String }

data Action
  = Add
  | Minus
  | Finish KeyValue

initialState :: Array String -> State
initialState keys = { keys: keys, mode: Start}

handleAction :: forall m. Action -> H.HalogenM State Action () KeyValue m Unit
handleAction = case _ of
  Add -> H.modify_ (setMode Adding)
  Minus -> H.modify_ (setMode Start)
  (Finish kv) -> H.raise kv

setMode :: Mode -> State -> State
setMode mode = _ {mode = mode}


render :: forall m. State -> H.ComponentHTML Action () m
render { keys, mode } = case mode of 
  Start -> 
    HH.div_ 
      [ HH.button [ HE.onClick \_ -> Add] [ HH.text "+" ]]
  Adding -> 
    HH.div_
      [ HH.button [ HE.onClick \_ -> Minus ] [HH.text "-"]
      , HH.form 
        [ HE.onSubmit \_ -> Finish {key: "Key", value: "Value"} ] 
        [ HH.label_ [HH.text "Key"] 
        , HH.input [ HP.type_ HP.InputText, HP.id "key"] 
        , HH.label_ [HH.text "Value"] 
        , HH.input [ HP.type_ HP.InputText, HP.id "value"] 
        , HH.button [  ] [ HH.text "Submit" ]
        ]
      ]
