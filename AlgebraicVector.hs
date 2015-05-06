-- file: ch03/AlgebraicVector.hs
--
data Cartesian2D = Cartesian2D Double Double 
                   deriving (Eq, Show)

data Polar2D = Polar2D Double Double
               deriving (Eq, Show)

-- This will fail, even though both types take numbers:
Cartesian2D (sqrt 2) (sqrt 2) == Polar2D (pi / 4) 2

-- Because the (==) operator requires the same type (doesn't do type coercion)
