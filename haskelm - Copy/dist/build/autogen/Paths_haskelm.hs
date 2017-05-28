{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_haskelm (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
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
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "C:\\Users\\Daniel\\AppData\\Roaming\\cabal\\bin"
libdir     = "C:\\Users\\Daniel\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-8.0.2\\haskelm-0.1.0.0-8hdVaD3nyskA2nYk3RJ0Yw"
dynlibdir  = "C:\\Users\\Daniel\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-8.0.2"
datadir    = "C:\\Users\\Daniel\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-8.0.2\\haskelm-0.1.0.0"
libexecdir = "C:\\Users\\Daniel\\AppData\\Roaming\\cabal\\haskelm-0.1.0.0-8hdVaD3nyskA2nYk3RJ0Yw"
sysconfdir = "C:\\Users\\Daniel\\AppData\\Roaming\\cabal\\etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "haskelm_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "haskelm_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "haskelm_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "haskelm_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "haskelm_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "haskelm_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
