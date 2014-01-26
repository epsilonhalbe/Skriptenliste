import Control.Monad (void)
import Control.Arrow ((&&&))
import Data.IORef ( newIORef
                  , readIORef
                  , writeIORef)
import Data.List (groupBy, sort, isInfixOf)
import Data.Char (toLower)
import System.Directory (getCurrentDirectory
                        ,getDirectoryContents)

import qualified Graphics.UI.Threepenny as UI
import Graphics.UI.Threepenny.Core

import Text.Parsec (ParseError)
import HTML
import Parser
import Data


main :: IO () --  startGUI defaultConfig { tpPort = 10000 } setup
main = do startGUI defaultConfig
              { tpPort       = 10000
              , tpStatic     = Just "./.wwwroot"
              } $ setup

setup :: Window -> UI ()
setup w = do
    return w # set title "<=Skriptenliste="
    UI.addStyleSheet w "stylesheet.css"
    folder <- liftIO getCurrentDirectory
    btnRescanFolder <- UI.button #. "button" #+ [string "Scan Folder"]
    elInput <- UI.input # set style [("width","300")] # set (attr "type") "text"
    inputs <- liftIO $ newIORef []

    let drawLayout :: UI ()
        drawLayout = void $ do [search] <- getValuesList [elInput]
                               layout <- mkLayout =<< liftIO (sFilter search `fmap` readIORef inputs)
                               getBody w # set children [layout]
                               UI.setFocus elInput

        mkLayout :: [String] -> UI Element
        mkLayout xs = column [UI.h1 # set text "Skriptenliste", UI.hr
                             ,UI.p #+[ UI.span # set text "Search: "
                                  , element elInput
                                  , element btnRescanFolder]
                             ,UI.ul #+ makeList xs
                             ,UI.hr
                             ,UI.span # set text "Copyright 2014 by Martin Heuschober"]

        rescanFolder :: UI ()
        rescanFolder = liftIO $ do fs <- sFilter ".pdf" `fmap` getDirectoryContents folder
                                   writeIORef inputs fs

        makeList :: [String] -> [UI Element]
        makeList ss = let groupedList = map leftOrAutor $ groupByFst leftRightAutor $ sort $ map (skriptum &&& id) ss
                      in  map (\(hl,lst) -> UI.li #+ [UI.h2 # set html (renderHTML hl), UI.ul #+ map items lst]) groupedList
                    where url file ="./"++(urlEscape file)
                          items (skrpt, fname) = UI.li #+ [UI.anchor # set UI.href (url fname)
                                                                     #+ [UI.span # set html (renderHTML $ skrpt)]]
    on (domEvent "livechange") elInput $ return drawLayout
    on UI.click btnRescanFolder $ \_ -> rescanFolder >> drawLayout
    rescanFolder
    drawLayout


sFilter :: String -> [String] -> [String]
sFilter search = filter (isInfixOf (tidyUp search) . tidyUp)
               where tidyUp = ignoreCase . ignoreWhitespace
                     ignoreCase = map toLower
                     ignoreWhitespace = filter (`notElem` " _\r\n\t")

groupByFst :: (a -> a -> Bool) -> [(a,b)] -> [[(a,b)]]
groupByFst f = groupBy (\x y -> f (fst x) (fst y))

leftRightAutor :: Either ParseError Skriptum -> Either ParseError Skriptum -> Bool
leftRightAutor (Left _) (Left _) = True
leftRightAutor (Right s1) (Right s2) = autor s1 == autor s2
leftRightAutor _ _ = False


leftOrAutor :: [(Either ParseError Skriptum,String)] -> (String, [(Either ParseError Skriptum,String)])
leftOrAutor [] = error "leftOrAutor: error empty list"
leftOrAutor x  = case fst $ head x of Left _  -> (warning, x)
                                      Right y -> (autor y, x)

warning :: String
warning = "Files not of the form: Autor_Titel_Typ_Semester_Jahr.pdf"

instance Eq ParseError
  where _ == _ = True

instance Ord ParseError where
  compare _ _ = EQ

