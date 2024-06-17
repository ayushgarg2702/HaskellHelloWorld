module Monad.CustomMonad where
import Prelude hiding (Nothing, Just)
import Data.Maybe (maybe)
import Control.Applicative (liftA2)


data CustomMaybeMonad a = Just a | Nothing

instance Functor CustomMaybeMonad where
    fmap _ Nothing = Nothing
    fmap f (Just a) = Just (f a)

instance Applicative CustomMaybeMonad where
    pure = Just
    Nothing <*> _ = Nothing
    (Just f) <*> mx = fmap f mx

instance Monad CustomMaybeMonad where
    return = pure
    Nothing >>= _ = Nothing
    (Just x) >>= f = f x

divide :: Double -> Double -> CustomMaybeMonad Double
divide _ 0 = Nothing
divide x y = Just (x / y)

functorExample :: CustomMaybeMonad Double
functorExample = fmap (+ 10) (divide 20 4)

applicativeExample :: CustomMaybeMonad Double
applicativeExample = liftA2 (+) (divide 20 4) (Just 10)

monadExample :: CustomMaybeMonad Double
monadExample = Just 20 >>= \x -> divide x 4 >>= \y -> return (y + 10)

liftCustomMonad :: CustomMaybeMonad a -> IO a
liftCustomMonad = customMaybe (error " ") return

customMaybe :: a -> (b -> a) -> CustomMaybeMonad b -> a
customMaybe def _ Nothing = def
customMaybe _ b (Just a) = b a

callCustomMonad :: IO Double
callCustomMonad = do
    print "customManad"
    a <- liftCustomMonad functorExample
    print (a)

    b <- liftCustomMonad applicativeExample
    print (b)

    c <- liftCustomMonad monadExample
    print (c)

    return 0.0