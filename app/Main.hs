{-# LANGUAGE LambdaCase #-}

module Main where

import Regex
  ( solve,
  )
import System.Environment
  ( getArgs,
    getProgName,
  )
import System.Exit
  ( exitFailure,
  )

main :: IO ()
main = do
  input <-
    getArgs >>= \case
      [] -> do
        pn <- getProgName
        putStrLn $ "Usage: " <> pn <> " <the.regexes>"
        exitFailure
      (fn : _) -> readFile fn
  print $ solve input
