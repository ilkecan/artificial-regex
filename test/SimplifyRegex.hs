module SimplifyRegex where

import Regex
  ( BracketShape (Round, Square),
    Regex (Bracket, Empty, Letter),
    simplifyRegex,
  )
import Test.Tasty.HUnit

-- "" -> ""
unit_simplifyEmpty :: Assertion
unit_simplifyEmpty = simplifyRegex Empty @?= Empty

-- "a" -> "a"
unit_simplifyLetter :: Assertion
unit_simplifyLetter = simplifyRegex (Letter 'a') @?= Letter 'a'

-- "()" -> ""
unit_simplifyEmptyParen :: Assertion
unit_simplifyEmptyParen = simplifyRegex (Bracket Round []) @?= Empty

-- "(a)" -> "a"
unit_simplifySingleInParen :: Assertion
unit_simplifySingleInParen = simplifyRegex (Bracket Round [Letter 'a']) @?= Letter 'a'

-- "(aa)" -> "(aa)"
unit_simplifyDuplicatedLettersInParen :: Assertion
unit_simplifyDuplicatedLettersInParen = simplifyRegex (Bracket Round [Letter 'a', Letter 'a']) @?= Bracket Round [Letter 'a', Letter 'a']

-- "[]" -> ""
unit_simplifyEmptyBracket :: Assertion
unit_simplifyEmptyBracket = simplifyRegex (Bracket Square []) @?= Empty

-- "[a]" -> "a"
unit_simplifySingleInBracket :: Assertion
unit_simplifySingleInBracket = simplifyRegex (Bracket Square [Letter 'a']) @?= Letter 'a'

-- "[aa]" -> "a"
unit_simplifyDuplicatedLettersInBracket :: Assertion
unit_simplifyDuplicatedLettersInBracket = simplifyRegex (Bracket Square [Letter 'a', Letter 'a']) @?= Letter 'a'

-- "(()())" -> ""
unit_simplifyNestedMultipleEmptyParen :: Assertion
unit_simplifyNestedMultipleEmptyParen = simplifyRegex (Bracket Round [Bracket Round [], Bracket Round []]) @?= Empty

-- "(a(bc))" -> "(abc)"
unit_simplifyNestedParen :: Assertion
unit_simplifyNestedParen = simplifyRegex (Bracket Round [Letter 'a', Bracket Round [Letter 'b', Letter 'c']]) @?= Bracket Round [Letter 'a', Letter 'b', Letter 'c']

-- "[[][]]" -> ""
unit_simplifyNestedMultipleEmptyBrackets :: Assertion
unit_simplifyNestedMultipleEmptyBrackets = simplifyRegex (Bracket Square [Bracket Square [], Bracket Square []]) @?= Empty

-- "[a[bc]]" -> "[abc]"
unit_simplifyNestedBracket :: Assertion
unit_simplifyNestedBracket = simplifyRegex (Bracket Square [Letter 'a', Bracket Square [Letter 'b', Letter 'c']]) @?= Bracket Square [Letter 'a', Letter 'b', Letter 'c']

-- "[a[[bb]b[[b]]](c)(d)]" -> "[abcd]"
unit_simplifyNestedMultipleLevels :: Assertion
unit_simplifyNestedMultipleLevels = simplifyRegex (Bracket Square [Letter 'a', Bracket Square [Bracket Square [Letter 'b', Letter 'b'], Letter 'b', Bracket Square [Bracket Square [Letter 'b']]], Bracket Round [Letter 'c'], Bracket Round [Letter 'd']]) @?= Bracket Square [Letter 'a', Letter 'b', Letter 'c', Letter 'd']

-- "[(ab)c(ab)]" -> "[(ab)c]"
unit_simplifyDuplicatedParensInBracket :: Assertion
unit_simplifyDuplicatedParensInBracket = simplifyRegex (Bracket Square [Bracket Round [Letter 'a', Letter 'b'], Letter 'c', Bracket Round [Letter 'a', Letter 'b']]) @?= Bracket Square [Bracket Round [Letter 'a', Letter 'b'], Letter 'c']
