module UnparseRegex where

import Regex
  ( BracketShape (Round, Square),
    Regex (Bracket, Empty, Letter),
    unparseRegex,
  )
import Test.Tasty.HUnit

unit_unparseEmpty :: Assertion
unit_unparseEmpty = unparseRegex Empty @?= ""

unit_unparseLetter :: Assertion
unit_unparseLetter = unparseRegex (Letter 'a') @?= "a"

unit_unparseEmptyParen :: Assertion
unit_unparseEmptyParen = unparseRegex (Bracket Round []) @?= "()"

unit_unparseParen :: Assertion
unit_unparseParen = unparseRegex (Bracket Round [Letter 'a', Letter 'b', Letter 'c']) @?= "(abc)"

unit_unparseEmptyBracket :: Assertion
unit_unparseEmptyBracket = unparseRegex (Bracket Square []) @?= "[]"

unit_unparseBracket :: Assertion
unit_unparseBracket = unparseRegex (Bracket Square [Letter 'a', Letter 'b', Letter 'c']) @?= "[abc]"

unit_unparseMixed :: Assertion
unit_unparseMixed = unparseRegex (Bracket Square [Letter 'a', Bracket Round [Letter 'b', Letter 'c']]) @?= "[a(bc)]"

unit_unparseNested :: Assertion
unit_unparseNested = unparseRegex (Bracket Square [Letter 'a', Bracket Square [Bracket Square [Letter 'b', Letter 'b'], Letter 'b', Bracket Square [Bracket Square [Letter 'b']]], Bracket Round [Letter 'c'], Bracket Round [Letter 'd']]) @?= "[a[[bb]b[[b]]](c)(d)]"
