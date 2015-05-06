-- file ch03/BookStore.hs
-- Introduction to data types
-- Using the 'data' keyword
data BookInfo = Book Int String [String]
                deriving (Show)

data MagazineInfo = Magazine Int String [String]
                    deriving (Show)

-- Creating a new value of type BookInfo:
myInfo = Book 97819741 "The Title of the Book" ["Jim Gaffigan", "Marley Dog"]

-- We treat the value constructor ('Book' or 'Magazine' above) as if it's just another function - 
-- one that takes the types described and returns a new values of the type we want.
data BookReview = BookReview BookInfo CustomerID String

-- The 'type' keyword is only for synonyms that already exist - purely readability.
type CustomerID = Int
type ReviewBody = String
type BookRecord = (BookInfo, BookReview)

-- Using types to clarify what we mean by 'String' in the BookReview type constructor
-- Couldn't this lead to some painful debugging? Do you always have access to .hs files for the type constructors?
-- (Also, what's the appropriate jargon here? data types? type constructors?)
-- If not, you'd have to load the module interactively and :type BookReview, :type BookInfo... etc etc 
-- until you understood all the types.
data BetterReview = BetterReview BookInfo CustomerID ReviewBody

-- Algebraic data types
-- Type that can have multiple value constructors
type CardHolder = String
type CardNumber = String
type Address = [String]

data BillingInfo = CreditCard CardHolder CardNumber Address
                 | CashOnDelivery
                 | Invoice CustomerID
                   deriving (Show)
