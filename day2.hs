#! /usr/bin/env nix-shell
#! nix-shell -i runghc -p "ghc.withPackages (p: [ p.bytestring p.containers ])"

{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE OverloadedStrings #-}

import qualified Data.ByteString.Char8 as BC
import Data.List (foldl')
import qualified Data.Map.Strict as M

main :: IO ()
main = do
  ids <- filter (not . BC.null) . BC.split '\n' <$> BC.readFile "day2.txt"

  let (two, three) = twoOrThreeTimes (countLetters <$> ids)
  putStr "Part 1: "
  print (two * three)

  let combinations = (,) <$> ids <*> ids
  putStr "Part 2: "
  BC.putStrLn (exactlyOneDifference combinations)


twoOrThreeTimes :: [M.Map Char Int] -> (Int, Int)
twoOrThreeTimes =
  flip foldl' (0, 0) $ \(!a, !b) x ->
    (a + fromEnum (2 `elem` x), b + fromEnum (3 `elem` x))

countLetters :: BC.ByteString -> M.Map Char Int
countLetters = BC.foldl' (\(!m) c -> M.insertWith (+) c 1 m) M.empty

exactlyOneDifference :: [(BC.ByteString, BC.ByteString)] -> BC.ByteString
exactlyOneDifference [] = "error"
exactlyOneDifference ((a, b):xs) =
  if (== 1) . sum $ BC.zipWith (\a b -> fromEnum (a /= b)) a b
  then mconcat $ BC.zipWith (\a b -> if a == b then BC.singleton a else BC.empty) a b
  else exactlyOneDifference xs
