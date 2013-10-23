{-# LANGUAGE OverloadedStrings, DeriveDataTypeable, RecordWildCards #-}
module Main where 

import Control.Monad (replicateM_)
import Control.Monad.IO.Class
import Data.ByteString.Lazy.Char8 (ByteString)
import Data.IORef -- Not good for threads but less dependecies than STM
import Data.Text (Text,unpack)
import Data.Text.Read (decimal)
import Network.HTTP.Types (ok200,badRequest400)
import Network.Wai
import Network.Wai.Handler.Warp (run)
import System.Console.CmdArgs.Implicit

import Ftdi

data Args = Args { device :: String
                 , port :: Int
                 } deriving (Show, Data, Typeable)

synopsis = Args { device = def &= argPos 0 &= typ "SERIAL"
                , port = 3000 &= help "HTTP port to listen to (default: 3000)"
                }
           &= program "vibraserver"
           &= summary "VibraServer v0.0.2"
           &= help ("Listens to given HTTP port and sends commands to "++
                    "Chinese vibrator device using FTDI TTL232R cable. "++
                    "First argument must be FTDI device serial number which "++
                    "can be obtained using `usb-devices` command."
                   )
main = do
  Args{..} <- cmdArgs synopsis
  putStrLn $ "Connecting " ++ show device ++ " and listening to port " ++ show port
  h <- new device
  var <- newIORef False
  run port $ app var h

app :: IORef Bool -> FtdiHandle -> Application
app var h req = case (requestMethod req,pathInfo req) of
  ("POST",["reset"]) -> do
    -- Reset state back to false if gets into desync
    liftIO $ onoff h
    liftIO $ writeIORef var False
    good "OK\n"
  ("POST",["on",skips]) -> do
    liftIO $ unlessVar False True $ onoff h
    case validateSkips skips of
      Just s -> do
        liftIO $ onoff h
        liftIO $ replicateM_ s $ function h
        good "OK\n"
      Nothing -> bad "Mode must be a integer between 0 and 37, inclusive\n"
  ("POST",["off"]) -> do
    liftIO $ unlessVar False False $ onoff h
    good "OK\n"
  ("POST",["function"]) -> do
    liftIO $ function h
    good "OK\n"
  _ -> bad "Unknown command\n"
  where
    unlessVar test newValue act = do
      x <- atomicModifyIORef var (\a -> (newValue,a==test))
      if x
        then return ()
        else act

bad,good :: Monad m => ByteString -> m Response
bad  = textualResponse badRequest400 
good = textualResponse ok200

textualResponse code text = return $
                            responseLBS code
                            [("Content-Type", "text/plain")]
                            text

validateSkips :: Integral a => Text -> Maybe a
validateSkips t = case decimal t of
  Right (a,"") -> if a<38
                  then Just a 
                  else Nothing
  _ -> Nothing
