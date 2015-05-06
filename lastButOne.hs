--Exercise in chapter 2.
--Write a function lastButOne which returns the element *before* the last
--

lastButOne xs = tail (take 2 (reverse xs)) 
--another solution could be:
--
-- penultimate xs = tail (init xs)
