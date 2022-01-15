module Solve where

import Regex
  ( solve,
  )
import Test.Tasty.HUnit

unit_solve :: Assertion
unit_solve = solve "[[a]b]\n((a)b)" @?= [(1, "((a)b)", "(ab)"), (2, "[[a]b]", "[ab]")]
