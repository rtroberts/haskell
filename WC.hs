--File: ch01/WC.hs
--Lines beginning with '--' are comments.
--
main = interact wordCount
  where wordCount input = show (length (words input)) ++ "\n"
