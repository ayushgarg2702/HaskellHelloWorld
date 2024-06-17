{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module DbConnection where

import Database.MySQL.Base
import qualified Data.ByteString.Char8 as BS

import qualified Database.PostgreSQL.Simple as DPSQL
import qualified Database.PostgreSQL.Simple.FromRow as DPSQLF
import Data.String (fromString)
import Database.PostgreSQL.Simple.FromRow (FromRow, field)
import Database.PostgreSQL.Simple.FromField
import Data.Aeson
import Data.Text
import GHC.Generics

-- Make maunal connection whith PSQL without library:
import qualified Network.Socket as NS
import System.IO
import Control.Exception (catch, IOException)

-- Function to establish a TCP connection to the PostgreSQL server with authentication
connectToPostgreSQL :: String -> Int -> String -> String -> String -> IO Handle
connectToPostgreSQL host port dbName username password = do
  putStrLn "Connecting to PostgreSQL server..."
  
  addrInfo <- NS.getAddrInfo Nothing (Just host) (Just $ show port)
  let serverAddr = Prelude.head addrInfo
  putStrLn $ "Resolved address: " ++ show serverAddr
  
  sock <- NS.socket (NS.addrFamily serverAddr) NS.Stream NS.defaultProtocol
  putStrLn "Socket created."

  NS.connect sock (NS.addrAddress serverAddr)
  putStrLn "Socket connected."

  h <- NS.socketToHandle sock ReadWriteMode
  hSetBuffering h LineBuffering
  putStrLn "Sending authentication information..."
  
  -- Send authentication information
  authenticate h username password `catch` handleAuthError


  -- Send database name
  putStrLn "Sending database name..."
  hPutStrLn h $ "DATABASE " ++ dbName
  response <- hGetLine h
  -- Check authentication response
  if response == "OK"
      then return h
      else error "Authentication failed"

authenticate :: Handle -> String -> String -> IO ()
authenticate h username password = do
  hPutStrLn h ("USER cloud")
  response1 <- hGetLine h
  if response1 /= "OK"
    then error "Authentication failed: USER command failed"
    else do
      hPutStrLn h $ "PASS scape"
      response2 <- hGetLine h
      if response2 /= "OK"
        then error "Authentication failed: PASS command failed"
        else return ()


handleAuthError :: IOException -> IO ()
handleAuthError e = do
  putStrLn $ "Authentication failed: " ++ show e
  error "Authentication failed"

makePsqlConnectionManualll :: IO ()
makePsqlConnectionManualll = return ()
    -- Replace these values with your PostgreSQL server's host, port, username, and password
    -- let host = "localhost"
    --     port = 5432
    --     username = "cloud"
    --     password = "scape"
    --     dbName   = "hpcldb"
    -- handle <- connectToPostgreSQL host port dbName username password
    -- hPutStrLn handle "SELECT * FROM example_table"
    -- response <- hGetLine handle
    -- putStrLn response
    -- hClose handle


---

data ExampleRecord = ExampleRecord
    { id :: Text
    , value :: Int
    } deriving (Show, Generic)

-- Automatically derive JSON instances
instance ToJSON ExampleRecord
instance FromJSON ExampleRecord

instance FromRow ExampleRecord where
    fromRow = ExampleRecord <$> field <*> field

-- instance Show ProcessTracker where
--   show (ProcessTracker id name tag runner retryCount scheduleTime rule trackingData businessStatus status event createdAt updatedAt) =
--     "ProcessTracker { id = " ++ show id ++ ", name = " ++ show name ++ ", tag = " ++ show tag ++ ", runner = " ++ show runner ++ ", retryCount = " ++ show retryCount ++ ", scheduleTime = " ++ show scheduleTime ++ ", rule = " ++ show rule ++ ", trackingData = " ++ show trackingData ++ ", businessStatus = " ++ show businessStatus ++ ", status = " ++ show status ++ ", event = " ++ show event ++ ", createdAt = " ++ show createdAt ++ ", updatedAt = " ++ show updatedAt ++ " }"

-- Function to establish a connection to MySQL
connectToMySQL :: IO MySQLConn
connectToMySQL = do
    conn <- connect $
      ConnectInfo {
        ciHost = "localhost",
        ciUser = BS.pack "helloWorld",
        ciPassword = BS.pack "scape",
        ciDatabase = BS.pack "jdb",
        ciPort = 3306,
        ciCharset = 33
      }
    putStrLn "Connected to MySQL database!"
    return conn


connectToPSQL :: IO ()
connectToPSQL = do
  conn <- DPSQL.connect DPSQL.defaultConnectInfo 
            { DPSQL.connectHost = "localhost"
            , DPSQL.connectPort = 5432
            , DPSQL.connectUser = "cloud"
            , DPSQL.connectPassword = "scape"
            , DPSQL.connectDatabase = "hpcldb"
            }

  let columnQuery = fromString "select * from example_table"
  
  result <- DPSQL.query_ conn columnQuery :: IO ([ExampleRecord])
  mapM_ print result 

  DPSQL.close conn
  pure ()
