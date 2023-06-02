module War (deal) where
import Data.List (sortBy)

-- populate hand with even indices of shuf
dealHelper1 :: [Int] -> [Int]
dealHelper1 shuf = reverse [ shuf !! i | i <- [0,2..length shuf - 1] ]

-- populate hand with odd indices of shuf
dealHelper2 :: [Int] -> [Int]
dealHelper2 shuf = reverse [ shuf !! i | i <- [1,3..length shuf - 1] ]

-- search for 1's change to 14
fixAces :: [Int] -> [Int] 
fixAces = map (\x -> if x == 1 then x + 13 else x)

-- search for 14's, revert to 1's
revertAces :: [Int] -> [Int]
revertAces = map (\x-> if x == 14 then x - 13 else x) 

deal :: [Int] -> [Int]
deal shuf = let
    --convert every 1 to 14 in shuffled cards to simplify comparisons later
    fixedshuf = fixAces shuf
    -- split the deck evenly
    p1 = dealHelper1 fixedshuf
    p2 = dealHelper2 fixedshuf
    winner = turn p1 p2 [] -- empty warchest
    -- store winning hand in win, then undo fix_aces()
    win = revertAces winner
  in win
 
-- function headers and base cases
turn :: [Int] -> [Int] -> [Int] -> [Int]
-- check for tie edgecase
turn [] [] warchest = (sortBy (flip compare) warchest)
-- check for p1 running out of cards
turn [] p2 warchest = p2 ++ (sortBy (flip compare) warchest)
-- check for p2 running out of cards
turn p1 [] warchest = p1 ++ (sortBy (flip compare) warchest)
-- if not base case, perform gameloop aka recursive case
turn (p1_top:p1_tail) (p2_top:p2_tail) warchest =
  -- compare top card rank
  case compare p1_top p2_top of
    -- recursively play with updated hands
    GT -> turn (p1_tail ++ (sortBy (flip compare) (p1_top:p2_top:warchest))) p2_tail []
    LT -> turn p1_tail (p2_tail ++ (sortBy (flip compare) (p2_top:p1_top:warchest))) []
    EQ ->
      -- same rank, check if war is possible recurse turn() and add matching cards to warchest
      if length p1_tail > 2 && length p2_tail > 2 then
        let d1:p1_tail' = p1_tail
            d2:p2_tail' = p2_tail
            warchest_new = warchest ++ [p1_top, p2_top, d1, d2]
        in turn p1_tail' p2_tail' (sortBy (flip compare) warchest_new)
      else
        turn p1_tail p2_tail (sortBy (flip compare) (p1_top:p2_top:warchest))
