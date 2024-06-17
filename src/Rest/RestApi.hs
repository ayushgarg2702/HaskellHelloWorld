module Rest.RestApi where

import Web.Scotty
import Data.Text.Lazy (pack)
import Katip
import RunSqlQuery
import Database.MySQL.Base

routes :: MySQLConn -> IO ()
routes con = do
   scotty 3002 $ do
    get (literal "/hello") $ do
      liftIO $ runQuery con
      -- liftIO $ print "ag"
      text $ pack "Hello, world!"

    get (literal "/hello2") $ do
      liftIO $ runQuery con
      -- liftIO $ print "ag"
      text $ pack "Hello, world! 2"
      -- Log a message at INFO level
      -- $(logTM) InfoS "Received request to /hello endpoint"
      -- Send "Hello, world!" response