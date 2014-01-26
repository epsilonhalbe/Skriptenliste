module Data where


data Skriptum = Skriptum { autor    :: String
                         , titel    :: String
                         , semester :: Maybe Semester
                         , jahr     :: Maybe Jahr
                         , pages    :: Maybe Page
                         , typ      :: Maybe Typ} deriving (Show, Eq, Ord)

data Semester = WS | SS deriving (Show,Eq,Ord)
data Typ = LaTeX | Manuskript | Mitschrift | VU | Prüfung | Übung deriving (Show, Eq,Ord)
newtype Jahr = J Int deriving (Show,Eq,Ord)
newtype Page = P Int deriving (Show,Eq,Ord)

