module Automaton(Automaton(..),
                 runAutomaton) where

import Data.Set(Set)
import Data.Map(Map)
import qualified Data.Set as Set
import qualified Data.Map as Map
import qualified Data.Maybe as Maybe
    
data Automaton q a = Automaton { state :: Set q,
                                 sigma :: Set a,
                                 delta :: Map q (Map a q),
                                 initial :: q,
                                 accepting :: Set q
                               }
                   deriving (Show,Read)

type Delta q a = Map q (Map a q)
iterar :: (Ord q, Ord a) => Delta q a -> q -> a -> Maybe q
iterar m q cc = do
  m' <- Map.lookup q m
  Map.lookup cc m'

runDelta:: (Ord q, Ord a) => Delta q a -> q -> [a] -> Maybe q
runDelta m q0 [x] = iterar m q0 x
runDelta m q0 (x:xs) = do q' <- iterar m q0 x
                          runDelta m q' xs

runAutomaton :: (Ord a, Ord q) => Automaton q a -> [a] -> Bool
runAutomaton auto xs = 
  if Maybe.isNothing $ result
    then False
    else Set.member (Maybe.fromJust result) (accepting auto) 
    where
      result = runDelta (delta auto) (initial auto) xs
-- Automata: 0 -a-> 1 -a-> 2 -a-> 3*
-- Automata de estado cero a uno leyendo la a hasta que llegue al estado de acceptacion 3*
auto1 = (read "Automaton {state = fromList [0,1,2,3], sigma = fromList \"a\", delta = fromList [(0,fromList [('a',1)]),(1,fromList [('a',2)]),(2,fromList [('a',3)])], initial = 0, accepting = fromList [3]}") :: Automaton Int Char

-- Automata: que lee la siguiente expresion regular aa*
auto2 = (read "Automaton {state = fromList [0,1], sigma = fromList \"a\", delta = fromList [(0,fromList [('a',1)]),(1,fromList [('a',1)])], initial = 0, accepting = fromList [1]}") :: Automaton Int Char

auto3 = (read "Automaton {state = fromList [0,1,2], sigma = fromList \"ab\", delta = fromList [(0,fromList [('a',1)]),(1,fromList [('a',2),('b',1)])], initial = 0, accepting = fromList [2]}") :: Automaton Int Char
auto4 = (read "Automaton {state = fromList ['a'_1, 'b'_2, 'b'_3, a'_4, 'c'_5, 'a'_6, 'c'_7], sigma = fromList \"abc\", delta = fromList [('a'_1,fromList ['a'_1,'b'_2,'a'_4]),('b'_2,fromList ['b'_3]),('b'_3,fromList ['a'_1,'b'_2,'a'_4]),('a'_4,fromList ['c'_5]),('c'_5,fromList ['a'_6]),('a'_6,fromList ['c'_7]),('c'_7,fromList ['a'_6])], initial = 'a'_1, accepting = fromList ['c'_5,'c'_7]}") :: Automaton Int Char
auto5 = (read "Automaton {state = fromList [0,1,2,3,4,5,6], sigma = fromList \"abc\", delta = fromList [(0,fromList ['a'_1,'b'_2,'a'_4]),(1,fromList ['b'_3]),(2,fromList ['a'_1,'b'_2,'a'_4]),(3,fromList ['c'_5]),(4,fromList ['a'_6]),(5,fromList ['c'_7]),(6,fromList ['a'_6])], initial = 'a'_1, accepting = fromList ['c'_5,'c'_7]}") :: Automaton Int Char
