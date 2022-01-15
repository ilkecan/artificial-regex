module ParseRegex where

import Regex
  ( BracketShape (Round, Square),
    Regex (Bracket, Letter),
    parseRegex,
  )
import Test.Tasty.HUnit

unit_parseEmpty :: Assertion
unit_parseEmpty = parseRegex "" @?= []

unit_parseLetter :: Assertion
unit_parseLetter = parseRegex "a" @?= [Letter 'a']

unit_parseMultipleLetters :: Assertion
unit_parseMultipleLetters = parseRegex "abc" @?= [Letter 'a', Letter 'b', Letter 'c']

unit_parseEmptyParen :: Assertion
unit_parseEmptyParen = parseRegex "()" @?= [Bracket Round []]

unit_parseParen :: Assertion
unit_parseParen = parseRegex "(abc)" @?= [Bracket Round [Letter 'a', Letter 'b', Letter 'c']]

unit_parseMultipleParens :: Assertion
unit_parseMultipleParens = parseRegex "(a)(ab)" @?= [Bracket Round [Letter 'a'], Bracket Round [Letter 'a', Letter 'b']]

unit_parseEmptyBracket :: Assertion
unit_parseEmptyBracket = parseRegex "[]" @?= [Bracket Square []]

unit_parseBracket :: Assertion
unit_parseBracket = parseRegex "[abc]" @?= [Bracket Square [Letter 'a', Letter 'b', Letter 'c']]

unit_parseMultipleMixed :: Assertion
unit_parseMultipleMixed = parseRegex "(a)b[cd]d" @?= [Bracket Round [Letter 'a'], Letter 'b', Bracket Square [Letter 'c', Letter 'd'], Letter 'd']

unit_parseMixed :: Assertion
unit_parseMixed = parseRegex "(a[bc])" @?= [Bracket Round [Letter 'a', Bracket Square [Letter 'b', Letter 'c']]]

unit_parseNested :: Assertion
unit_parseNested = parseRegex "[a[[bb]b[[b]]](c)(d)]" @?= [Bracket Square [Letter 'a', Bracket Square [Bracket Square [Letter 'b', Letter 'b'], Letter 'b', Bracket Square [Bracket Square [Letter 'b']]], Bracket Round [Letter 'c'], Bracket Round [Letter 'd']]]
