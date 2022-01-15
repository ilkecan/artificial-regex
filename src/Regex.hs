module Regex
  ( parseRegex,
    unparseRegex,
    simplifyRegex,
    countMatched,
    solve,
    Regex (Empty, Letter, Bracket),
    BracketShape (Round, Square),
  )
where

import Data.Bimap as B
  ( Bimap,
    fromList,
    memberR,
    (!),
    (!>),
  )
import Data.List
  ( sortOn,
  )
import Data.List.Extra
  ( nubOrd,
  )
import Data.List.NonEmpty as NE
  ( NonEmpty ((:|)),
    fromList,
  )
import Data.Tuple.Extra
  ( fst3,
  )

-- | Data type that represents the types of regexes.
data Regex
  = Empty
  | Letter !Char
  | Bracket !BracketShape ![Regex]
  deriving (Show, Eq, Ord)

-- | Data type that represents the shapes of brackets.
data BracketShape
  = Round
  | Square
  deriving (Show, Eq, Ord, Enum, Bounded)

-- | Bidirectional mapping between the shapes of the brackets and their left
-- lexemes.
leftBrackets :: Bimap BracketShape Char
leftBrackets =
  B.fromList
    [ (Round, '('),
      (Square, '[')
    ]

-- | Bidirectional mapping between the shapes of the brackets and their right
-- lexemes.
rightBrackets :: Bimap BracketShape Char
rightBrackets =
  B.fromList
    [ (Round, ')'),
      (Square, ']')
    ]

-- | Given a token, stops the execution and displays a error message saying the
-- token was unexpected.
unexpectedToken :: Char -> a
unexpectedToken token = error $ "Unexpected token: '" <> show token <> "'"

-- | Given a token, stops the execution and displays a error message saying the
-- token was missing.
missingToken :: Char -> a
missingToken token = error $ "Missing token: '" <> show token <> "'"

solve :: String -> [(Int, String, String)]
solve = sortOn fst3 . map solveLine . lines

-- | Given the string representation of a regex, returns a 3-tuple according to
-- the "Regex fun" specification.
solveLine :: String -> (Int, String, String)
solveLine regex = (numberOfMatched, regex, unparseRegex simplified)
  where
    simplified = simplifyRegex . Bracket Round . parseRegex $ regex
    numberOfMatched = countMatched simplified

-- | Given a string to parse from, returns the parsed regexes.
parseRegex :: String -> [Regex]
parseRegex "" = []
parseRegex str = regex : parseRegex rest
  where
    (regex, rest) = parseRegex' $ NE.fromList str

parseRegex' :: NonEmpty Char -> (Regex, String)
parseRegex' (next :| rest)
  | memberR next leftBrackets = parseBracket (leftBrackets !> next) rest
  | memberR next rightBrackets = unexpectedToken next
  | otherwise = (Letter next, rest)

-- | Given the shape and the string to parse from, returns the parsed bracket
-- type regex and the unparsed substring as a pair.
parseBracket :: BracketShape -> String -> (Regex, String)
parseBracket shape str = (Bracket shape regexes, rest)
  where
    (regexes, rest) = parseUntil (rightBrackets ! shape) str []

parseUntil :: Char -> String -> [Regex] -> ([Regex], String)
parseUntil terminator "" _ = missingToken terminator
parseUntil terminator (next : rest) regexes
  | memberR next rightBrackets =
    if next == terminator
      then (regexes, rest)
      else unexpectedToken next
parseUntil terminator str regexes =
  parseUntil terminator rest (regexes ++ [regex])
  where
    (regex, rest) = parseRegex' $ NE.fromList str

-- | Given a regex, returns the simplified version of it.
simplifyRegex :: Regex -> Regex
simplifyRegex (Bracket shape regexes) = simplifyBracket shape regexes
simplifyRegex regex = regex

-- | Given the shape of a bracket type regex and the regexes that it surrounds,
-- returns the simplified version it.
simplifyBracket :: BracketShape -> [Regex] -> Regex
simplifyBracket shape regexes =
  case simplify . simplifyEnclosed shape $ regexes of
    [] -> Empty
    [regex] -> regex
    regexes' -> Bracket shape regexes'
  where
    f = case shape of
      Round -> id
      Square -> nubOrd
    simplify = filter (/= Empty) . f

-- | Given the shape of a bracket type regex and the regexes that it surrounds,
-- returns the simplified version of the surrounded regexes.
simplifyEnclosed :: BracketShape -> [Regex] -> [Regex]
simplifyEnclosed shape = concatMap $ f . simplifyRegex
  where
    f (Bracket shape' regexes') | shape' == shape = regexes'
    f regex = [regex]

-- | Given a simplified regex, returns the number of different strings it can
-- match.
countMatched :: Regex -> Int
countMatched Empty = 0
countMatched (Letter _) = 1
countMatched (Bracket shape regexes) =
  f $ map countMatched regexes
  where
    f = case shape of
      Round -> product
      Square -> sum

-- | Given a regex, returns the string representation of it.
unparseRegex :: Regex -> String
unparseRegex Empty = ""
unparseRegex (Letter char) = [char]
unparseRegex (Bracket shape regexes) =
  leftBrackets ! shape :
  concatMap unparseRegex regexes
    ++ [rightBrackets ! shape]
