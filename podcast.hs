module Podcast where

import Control.Applicative
import Data.List
import Data.Time
import Data.Time.Format
import System.Locale
import System.Environment

data MessageType = Success
                 | Continue
                 | Redirect
                 | Other Int
                 | Error Int
  deriving (Show, Ord, Eq)

data LogMessage = LogMessage MessageType TimeStamp Podcast String
                | Unknown String
  deriving (Show, Ord, Eq)

type TimeStamp = UTCTime
type Podcast = String


main = do
  listOfFiles <- getArgs
  contentsList <- fmap concat  (mapM readFile listOfFiles)
  parseLog parse showStats listOfFiles
  --sequence_ (map applyParsing listOfFiles)
  --[ parseLog parse showStats x | x <- listOfFiles ] 

--Maybe do this differently. Read each file and get the results, then merge the results of each file before output.

parseLog :: (String -> [LogMessage])
         -> ([LogMessage] -> [String])
         -> [FilePath]
         -> IO [String]
--parseLog parse showStats file = showStats (parse <$> file)
parseLog parse showStats file = showStats . parse <$> (fmap concat (mapM readFile file))


--applyParsing :: FilePath -> IO [String]
--applyParsing file = parseLog parse showStats file


readMany :: [FilePath] -> IO String
readMany n = unlines <$> mapM readFile n

parseMessage :: String -> LogMessage
parseMessage n = case removeData n of
                   (time:podcast:"200":string) -> LogMessage Success (podParseTime time) podcast (unwords string)
                   (time:podcast:"206":string) -> LogMessage Continue (podParseTime time) podcast (unwords string)
                   (time:podcast:"301":string) -> LogMessage Redirect (podParseTime time) podcast (unwords string)
                   (time:podcast:code:string) -> LogMessage (Other (read code)) (podParseTime time) podcast (unwords string)
                   _ -> Unknown n  

removeData :: String -> [String] 
removeData n = case words n of 
                   (_:_:time:_:_:_:_:_:podcast:_:_:_:code:_:_:_:_:_:_:string) -> (time:podcast:code:string)
                   _ -> n:[]

parse :: String -> [LogMessage]
parse n = lines n |> applyFilters |> map parseMessage 

podParseTime :: String -> UTCTime
podParseTime n = readTime defaultTimeLocale "%d/%b/%Y:%H:%M:%S" n

notCrap :: Char -> Bool
notCrap n
  | n =='"' = False
  | n ==';' = False
  | n =='[' = False
  | n ==']' = False
  | otherwise = True

applyFilters :: [String] -> [String]
applyFilters n = n |> map (filter notCrap)

showStats :: [LogMessage] -> [String] 
showStats n = filter isSuccessful n |> map getPodcast |> filter (isInfixOf ".mp3") |> frequency |> sort |> map putFrequency
  where isSuccessful (LogMessage Success _ _ _) = True
        isSuccessful _ = False
        getPodcast (LogMessage _ _ podcast _) = podcast

putFrequency :: (Int, Podcast) -> String
putFrequency (number, name) = show number ++ " downloads of " ++ name

frequency :: Ord a => [a] -> [(Int,a)] 
frequency list = map (\l -> (length l, head l)) (group (sort list))


(|>) x y = y x

-- | @parseLog p n f@ tests the log file parser @p@ by running it
----   on the first @n@ lines of file @f@.
--testParseLog :: (String -> [LogMessage])
--             -> Int
--             -> FilePath
--             -> IO [LogMessage]
--testParseLog parse n file = take n . parse <$> readFile file

