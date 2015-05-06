--Exercise 01: We need to first find the digits of a number. Define the functions:
toDigitsRev :: Integer -> [Integer]
toDigitsRev 0 = []
toDigitsRev n
  | n < 0 = []
  | otherwise = (mod n 10) : toDigitsRev (div n 10)

toDigits :: Integer -> [Integer]
toDigits n = reverse (toDigitsRev n) 

--This is so hard. It may be easy if it started from the left, but the homework makes you calculate every other 
--digit starting from the RIGHT. Wtf.
doubleEveryOtherRev :: [Integer] -> [Integer]
doubleEveryOtherRev [] = []
doubleEveryOtherRev (x:[]) = [x]
doubleEveryOtherRev (x:y:ns) = x : (2*y) : doubleEveryOtherRev ns

doubleEveryOther :: [Integer] -> [Integer]
doubleEveryOther n = (reverse (doubleEveryOtherRev (reverse n)))

--I'm sure I could avoid calling toDigits and sum on EVERY element here, but I didn't want to copy some guy online.
--Like I did for the rest of this.
sumDigits :: [Integer] -> Integer
sumDigits [] = 0 
sumDigits (x:xs) = sum (toDigits x) + sumDigits xs


validate :: Integer -> Bool
validate n = (mod (sumDigits (doubleEveryOther (toDigits n))) 10) == 0



--Tower of Hanoi
type Peg = String
type Move = (Peg, Peg)
hanoi :: Integer -> Peg -> Peg -> Peg -> [Move]
hanoi 0 _ _ _ = [] 
hanoi n a b c = hanoi (n-1) a c b ++ [(a,b)] ++ hanoi (n-1) c b a
