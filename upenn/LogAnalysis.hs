{-# OPTIONS_GHC -Wall #-}
module LogAnalysis where
import Log

--This is super useful - I like the idea of elixir pipes in Haskell. Takes care of a really big gripe
--I have with the language (namely that function composition is awkward compared to Ruby method chains or 
--unix pipes)

(|>) x y = y x

parseMessage :: String -> LogMessage
parseMessage n = case words n of
                   ("I":time:string) -> LogMessage Info (read time) (unwords string)  
                   ("W":time:string) -> LogMessage Warning (read time) (unwords string)
                   ("E":number:time:string) -> LogMessage (Error (read number)) (read time) (unwords string) 
                   _ -> Unknown n  

-- I got this all by myself. I'm actually pretty proud of this. Never really used map; it doesn't make (as much) sense in Ruby.
parse :: String -> [LogMessage]
parse n = map parseMessage (lines n)

-- This is tough.
insert :: LogMessage -> MessageTree -> MessageTree
insert (Unknown _) mt = mt
insert msg (Leaf) = Node Leaf msg Leaf
insert msg@(LogMessage _ ts _) (Node left root@(LogMessage _ rts _) right) =
  if ts < rts then
              Node (insert msg left) root right
              else
              Node left root (insert msg right)


build :: [LogMessage] -> MessageTree
build = foldr insert Leaf


inOrder :: MessageTree -> [LogMessage]
inOrder Leaf = []
inOrder (Node left root right) = 
  inOrder left ++ [root] ++ inOrder right


whatWentWrong :: [LogMessage] -> [String]
whatWentWrong n = build n |> inOrder |> filter isSevereError |> map getError
  where isSevereError (LogMessage (Error num) _ _) = num >= 50
        isSevereError _ = False
        getError (LogMessage (Error _) _ string) = string
