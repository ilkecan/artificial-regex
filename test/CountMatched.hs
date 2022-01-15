module CountMatched where

import Regex
  ( BracketShape (Round, Square),
    Regex (Bracket, Empty, Letter),
    countMatched,
  )
import Test.Tasty.HUnit

-- note that the regex should be in the simplified form

-- ""
unit_countMatchedEmpty :: Assertion
unit_countMatchedEmpty = countMatched Empty @?= 0

-- "a"
unit_countMatchedLetter :: Assertion
unit_countMatchedLetter = countMatched (Letter 'a') @?= 1

-- "(abc)"
unit_countMatchedParen :: Assertion
unit_countMatchedParen = countMatched (Bracket Round [Letter 'a', Letter 'b', Letter 'c']) @?= 1

-- "["abc"]
unit_countMatchedBracket :: Assertion
unit_countMatchedBracket = countMatched (Bracket Square [Letter 'a', Letter 'b', Letter 'c']) @?= 3

-- "(a[b(cd)])"
unit_countMatchedMixed :: Assertion
unit_countMatchedMixed = countMatched (Bracket Round [Letter 'a', Bracket Square [Letter 'b', Bracket Round [Letter 'c', Letter 'd']]]) @?= 2
