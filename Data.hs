module Skriptenliste.Data where

data Skriptum = Skriptum { _titel    :: String
                         , _autor    :: String
                         , _semester :: Maybe Semester
                         , _jahr     :: Maybe Jahr
                         , _pages    :: Maybe Page
                         , _typ      :: Maybe Typ} deriving (Show, Eq)

data Semester = WS | SS deriving (Show,Eq)
data Typ = LaTeX | Mitschrift deriving (Show, Eq)
newtype Jahr = J Int deriving (Show,Eq)
newtype Page = P Int deriving (Show,Eq)

