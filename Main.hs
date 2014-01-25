
import Control.Monad (void)
import Data.IORef ( newIORef
                  , readIORef
                  , writeIORef)
import Data.List
import Data.Char (toLower)
import System.Directory
import System.Environment (getArgs)

import qualified Graphics.UI.Threepenny as UI
import Graphics.UI.Threepenny.Core


main :: IO ()
main = startGUI defaultConfig { tpPort = 10000 } setup

setup :: Window -> UI ()
setup w = do
    return w # set title "<=Skriptenliste="
    home <- liftIO getHomeDirectory
    target <- liftIO getArgs
    let folder = home ++ "/" ++ if null target then "Downloads"
                                               else head target
    (btnRescanFolder, viewRescanFolder) <- mkButton "Scan Folder"
    elInput <- UI.input # set text ""
    inputs <- liftIO $ newIORef []

    let drawLayout :: UI ()
        drawLayout = void $ do [search] <- getValuesList [elInput]
                               layout <- mkLayout =<< liftIO (sFilter search `fmap` readIORef inputs)
                               getBody w # set children [layout]
                               UI.setFocus elInput

        mkLayout :: [String] -> UI Element
        mkLayout xs = column [UI.h1 # set text "Skriptenliste", UI.hr
                             ,row [UI.span # set text "Search: " ,element elInput]
                             ,return viewRescanFolder
                             ,UI.ul #+ makeList xs
                             ,UI.hr
                             ,UI.span # set text "Copyright 2014 by Martin Heuschober"]

        rescanFolder :: UI ()
        rescanFolder = liftIO $ do fs <- sFilter ".pdf" `fmap` getDirectoryContents folder
                                   mapM_ putStrLn fs
                                   writeIORef inputs fs

        makeList :: [String] -> [UI Element]
        makeList = map (\fname -> UI.li #+ [UI.a # set UI.href ("file://"++folder++"/"++fname)
                                                 #+ [string {- .renderHTML -} fname]])

    on (domEvent "livechange") elInput $ return drawLayout
    on UI.click btnRescanFolder $ \_ -> rescanFolder >> drawLayout
    rescanFolder
    drawLayout


sFilter :: String -> [String] -> [String]
sFilter search = filter (isInfixOf (tidyUp search) . tidyUp)
               where tidyUp = ignoreCase . ignoreWhitespace
                     ignoreCase = map toLower
                     ignoreWhitespace = filter (`notElem` " _\r\n\t")

mkButton :: String -> UI (Element, Element)
mkButton t = do
    button <- UI.button #. "button" #+ [string t]
    view   <- UI.p #+ [element button]
    return (button, view)


