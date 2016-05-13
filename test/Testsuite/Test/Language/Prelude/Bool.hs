{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

module Test.Language.Prelude.Bool (tests) where



import Data.Bool
import Data.Monoid

import qualified Stg.Language.Prelude as Stg
import           Stg.Parser

import Test.Machine.Evaluate.TestTemplates.HaskellReference
import Test.Orphans                                         ()
import Test.Tasty



tests :: TestTree
tests = testGroup "Bool"
    [ testAnd2
    , testOr2
    , testNot
    , testBool ]

testAnd2 :: TestTree
testAnd2 = haskellReferenceTest HaskellReferenceTestSpec
    { testName = "and2 (&&)"
    , maxSteps = 1024
    , failWithInfo = False
    , successPredicate = "main" ===> [stg| () \n () -> Success () |]
    , failPredicate = const False
    , source = \(b1, b2) ->
           Stg.boolValue "b1" b1
        <> Stg.boolValue "b2" b2
        <> Stg.boolValue "expectedResult" (b1 && b2)
        <> Stg.eq_Bool
        <> Stg.and2
        <> [stg|
        main = () \u () -> case and2 (b1, b2) of
                result -> case eq_Bool (result, expectedResult) of
                    True () -> Success ();
                    False () -> TestFail (result);
                    badBool -> Error (badBool)
        |] }

testOr2 :: TestTree
testOr2 = haskellReferenceTest HaskellReferenceTestSpec
    { testName = "or2 (||)"
    , maxSteps = 1024
    , failWithInfo = False
    , successPredicate = "main" ===> [stg| () \n () -> Success () |]
    , failPredicate = const False
    , source = \(b1, b2) ->
           Stg.boolValue "b1" b1
        <> Stg.boolValue "b2" b2
        <> Stg.boolValue "expectedResult" (b1 || b2)
        <> Stg.eq_Bool
        <> Stg.or2
        <> [stg|
        main = () \u () -> case or2 (b1, b2) of
                result -> case eq_Bool (result, expectedResult) of
                    True () -> Success ();
                    False () -> TestFail (result);
                    badBool -> Error (badBool)
        |] }

testNot :: TestTree
testNot = haskellReferenceTest HaskellReferenceTestSpec
    { testName = "not"
    , maxSteps = 1024
    , failWithInfo = False
    , successPredicate = "main" ===> [stg| () \n () -> Success () |]
    , failPredicate = const False
    , source = \b ->
           Stg.boolValue "b" b
        <> Stg.boolValue "expectedResult" (not b)
        <> Stg.eq_Bool
        <> Stg.not
        <> [stg|
        main = () \u () -> case not (b) of
                result -> case eq_Bool (result, expectedResult) of
                    True () -> Success ();
                    False () -> TestFail (result);
                    badBool -> Error (badBool)
        |] }

testBool :: TestTree
testBool = haskellReferenceTest HaskellReferenceTestSpec
    { testName = "bool"
    , maxSteps = 1024
    , failWithInfo = True
    , successPredicate = "main" ===> [stg| () \n () -> Success () |]
    , failPredicate = const False
    , source = \(t,f,p) ->
           Stg.boolValue "p" p
        <> Stg.int "t" t
        <> Stg.int "f" f
        <> Stg.int "expectedResult" (bool t f p)
        <> Stg.eq_Int
        <> Stg.bool
        <> [stg|
        main = () \u () -> case bool (t,f,p) of
                result -> case eq_Int (result, expectedResult) of
                    True () -> Success ();
                    False () -> TestFail (result);
                    badBool -> Error (badBool)
        |] }
