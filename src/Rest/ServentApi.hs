{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}

module Rest.ServentApi where

import GHC.Generics
import Data.Aeson
import Network.Wai.Handler.Warp (run)
import Servant
import Servant.API
import Data.Text (Text)
import Data.Proxy

-- Define API types
type API = "get1" :> Get '[JSON] Text
            :<|> "get2" :> Get '[JSON] Text
            :<|> "post1" :> ReqBody '[JSON] Text :> Post '[JSON] Text
            :<|> "post2" :> ReqBody '[JSON] Text :> Post '[JSON] Text

server :: Server API
server = get1Handler
    :<|> get2Handler
    :<|> post1Handler
    :<|> post2Handler

get1Handler :: Handler Text
get1Handler = return "get1Handler"

get2Handler :: Handler Text
get2Handler = return "get2Handler"

post2Handler :: Text -> Handler Text
post2Handler _ = return "post2Handler"

post1Handler :: Text -> Handler Text
post1Handler _ = return "post1Handler"

runServantApi :: IO ()
runServantApi = run 8083 (serve (Proxy :: Proxy API) server)