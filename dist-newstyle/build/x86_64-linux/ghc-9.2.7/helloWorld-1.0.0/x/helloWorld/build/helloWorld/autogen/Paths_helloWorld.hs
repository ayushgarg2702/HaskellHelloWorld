{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_helloWorld (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [1,0,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath



bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/home/ayush/.cabal/bin"
libdir     = "/home/ayush/.cabal/lib/x86_64-linux-ghc-9.2.7/helloWorld-1.0.0-inplace-helloWorld"
dynlibdir  = "/home/ayush/.cabal/lib/x86_64-linux-ghc-9.2.7"
datadir    = "/home/ayush/.cabal/share/x86_64-linux-ghc-9.2.7/helloWorld-1.0.0"
libexecdir = "/home/ayush/.cabal/libexec/x86_64-linux-ghc-9.2.7/helloWorld-1.0.0"
sysconfdir = "/home/ayush/.cabal/etc"

getBinDir     = catchIO (getEnv "helloWorld_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "helloWorld_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "helloWorld_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "helloWorld_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "helloWorld_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "helloWorld_sysconfdir") (\_ -> return sysconfdir)




joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '/'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/'
