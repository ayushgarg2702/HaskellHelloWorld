module Main where
import DbConnection
import RunSqlQuery
import Database.MySQL.Base
import Rest.RestApi
import Monad.CustomMonad
import Rest.ServentApi

main :: IO ()
main = do
  conn <- connectToMySQL
  callCustomMonad
  print "123"
  pure "123"
  print "1233454"

  print "ManualPsqlConnection"
  makePsqlConnectionManualll
  print "ManualPsqlConnection"

  print "psql"
  connectToPSQL
  print "psql"

  runQuery conn

  runServantApi

  routes conn
  close conn
  putStrLn "Hello, World!"

  putStrLn "Work done"
