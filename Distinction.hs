-- file: ch03/Distinction.hs
-- The ability to make new types like this prevents us from passing a Table to a function that expects a dolphin - even though they are both Strings.
data Cetacean = Cetacean String String
data Furniture = Furniture String String

c = Cetaean "Porpoise" "Grey"
f = Furniture "Table" "Oak"
