module RunSqlQuery where

import qualified Data.Text.Encoding as TE
import qualified Data.ByteString.Lazy.Char8 as BL
import qualified Database.MySQL.Base as DBL
import qualified System.IO.Streams as Streams
import Tyes.Customer
import Control.Monad.Trans (liftIO)

-- Define the function to run a query
runQuery :: DBL.MySQLConn -> IO ()
runQuery conn = do
  print "q"

  let columnQuery = DBL.Query $ BL.pack ("SELECT * from customer limit 2")
  print "q"
  (columnDefinitions, outputStream) <- liftIO $ DBL.query_ conn columnQuery

  print "q"
  output <- Streams.toList outputStream

  let flattenedValues = concat output
      parseResponse = parseCustomer flattenedValues
      parseArrayResponse = map parseCustomer output
  mapM_ print output
  -- print columnQuery
  print ""

  print flattenedValues
  print ""
  print parseResponse
  print ""
  print parseArrayResponse
  return ()