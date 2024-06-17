module Tyes.Customer where

import Data.Text (Text, strip)
import Data.Time.LocalTime (LocalTime)
import Data.Maybe (fromMaybe)
import Database.MySQL.Base
import qualified Data.Text as T

newtype CustomerId = CustomerId Text
  deriving (Show, Eq)

data Customer = Customer
  { _id               :: Maybe CustomerId
  , version           :: Int
  , dateCreated       :: LocalTime
  , emailAddress      :: Maybe Text
  , firstName         :: Maybe Text
  , lastName          :: Maybe Text
  , lastUpdated       :: LocalTime
  , merchantAccountId :: Int
  , mobileCountryCode :: Text
  , mobileNumber      :: Text
  , objectReferenceId :: Maybe Text
  , objectReferenceIdHash :: Maybe Text
  , encryptionKeyId   :: Maybe Text
  , mobileNumberHash  :: Maybe Text
  }
  deriving (Show)


parseCustomer :: [MySQLValue] -> Maybe Customer
parseCustomer [ MySQLText customerId
              , MySQLInt64 version
              , MySQLDateTime dateCreated
              , emailAddress
              , firstName
              , lastName
              , MySQLDateTime lastUpdated
              , MySQLInt64 merchantAccountId
              , MySQLText mobileCountryCode
              , MySQLText mobileNumber
              , objectReferenceId
              , objectReferenceIdHash
              , encryptionKeyId
              , mobileNumberHash ] =
    Just $ Customer
        { _id = Just (CustomerId customerId)
        , version = fromIntegral version
        , dateCreated = dateCreated
        , emailAddress = parseTextValue emailAddress
        , firstName = parseTextValue firstName
        , lastName = parseTextValue lastName
        , lastUpdated = lastUpdated
        , merchantAccountId = fromIntegral merchantAccountId
        , mobileCountryCode = mobileCountryCode
        , mobileNumber = mobileNumber
        , objectReferenceId = parseTextValue objectReferenceId
        , objectReferenceIdHash = parseTextValue objectReferenceIdHash
        , encryptionKeyId = parseTextValue encryptionKeyId
        , mobileNumberHash = parseTextValue mobileNumberHash
        }
  where
    parseTextValue :: MySQLValue -> Maybe Text
    parseTextValue (MySQLText text) = Just text
    parseTextValue MySQLNull = Nothing
    parseTextValue _ = Nothing
parseCustomer _ = Nothing

nullText :: Text -> Bool
nullText = T.null . T.strip

unpackMySQLText :: MySQLValue -> Text
unpackMySQLText (MySQLText text) = text
unpackMySQLText _ = T.pack ""
