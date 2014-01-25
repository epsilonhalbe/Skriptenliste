{-# LANGUAGE FlexibleInstances #-}

module Skriptenliste.HTML where

import Text.Parsec
import Skriptenliste.Data


class HTML a where
  renderHTML :: a -> String

instance HTML (Either ParseError Skriptum)
  where renderHTML (Left msg) = "<p style=\"color:red\">"++
                                    renderHTML (show msg)++
                                "</p>"

instance HTML Skriptum
  where renderHTML (Skriptum t a s j p typ) = bold   (renderHTML a)++", "++
                                              italic (renderHTML t)++
                                                      renderHTML s ++
                                                      renderHTML j ++
                                                      renderHTML p ++
                                                      renderHTML typ
                                            where bold   text = "<b>"++text++"</b>"
                                                  italic text = "<i>"++text++"</i>"

instance (HTML a) => HTML (Maybe a)
  where renderHTML Nothing = ""
        renderHTML (Just a) = renderHTML a

instance HTML Semester
  where renderHTML WS = ", WS"
        renderHTML SS = ", SS"

instance HTML Jahr
  where renderHTML (J j) = ' ':show j

instance HTML Page
  where renderHTML (P p) = ", p. "++show p

instance HTML Typ
  where renderHTML t = " ("++show t++")"

instance HTML String
  where renderHTML = concatMap escape

escape :: Char -> String
escape '"' = "&quot;"
escape '\''= "&apos;"
escape '&' = "&amp;"
escape '<' = "&lt;"
escape '>' = "&gt;"
escape ' ' = "&nbsp;"
escape '¡' = "&iexcl;"
escape '¢' = "&cent;"
escape '£' = "&pound;"
escape '¤' = "&curren;"
escape '¥' = "&yen;"
escape '¦' = "&brvbar;"
escape '§' = "&sect;"
escape '¨' = "&uml;"
escape '©' = "&copy;"
escape 'ª' = "&ordf;"
escape '«' = "&laquo;"
escape '¬' = "&not;"
escape '�' = "&shy;"
escape '®' = "&reg;"
escape '¯' = "&macr;"
escape '°' = "&deg;"
escape '±' = "&plusmn;"
escape '²' = "&sup2;"
escape '³' = "&sup3;"
escape '´' = "&acute;"
escape 'µ' = "&micro;"
escape '¶' = "&para;"
escape '·' = "&middot;"
escape '¸' = "&cedil;"
escape '¹' = "&sup1;"
escape 'º' = "&ordm;"
escape '»' = "&raquo;"
escape '¼' = "&frac14;"
escape '½' = "&frac12;"
escape '¾' = "&frac34;"
escape '¿' = "&iquest;"
escape '×' = "&times;"
escape '÷' = "&divide;"
escape 'À' = "&Agrave;"
escape 'Á' = "&Aacute;"
escape 'Â' = "&Acirc;"
escape 'Ã' = "&Atilde;"
escape 'Ä' = "&Auml;"
escape 'Å' = "&Aring;"
escape 'Æ' = "&AElig;"
escape 'Ç' = "&Ccedil;"
escape 'È' = "&Egrave;"
escape 'É' = "&Eacute;"
escape 'Ê' = "&Ecirc;"
escape 'Ë' = "&Euml;"
escape 'Ì' = "&Igrave;"
escape 'Í' = "&Iacute;"
escape 'Î' = "&Icirc;"
escape 'Ï' = "&Iuml;"
escape 'Ð' = "&ETH;"
escape 'Ñ' = "&Ntilde;"
escape 'Ò' = "&Ograve;"
escape 'Ó' = "&Oacute;"
escape 'Ô' = "&Ocirc;"
escape 'Õ' = "&Otilde;"
escape 'Ö' = "&Ouml;"
escape 'Ø' = "&Oslash;"
escape 'Ù' = "&Ugrave;"
escape 'Ú' = "&Uacute;"
escape 'Û' = "&Ucirc;"
escape 'Ü' = "&Uuml;"
escape 'Ý' = "&Yacute;"
escape 'Þ' = "&THORN;"
escape 'ß' = "&szlig;"
escape 'à' = "&agrave;"
escape 'á' = "&aacute;"
escape 'â' = "&acirc;"
escape 'ã' = "&atilde;"
escape 'ä' = "&auml;"
escape 'å' = "&aring;"
escape 'æ' = "&aelig;"
escape 'ç' = "&ccedil;"
escape 'è' = "&egrave;"
escape 'é' = "&eacute;"
escape 'ê' = "&ecirc;"
escape 'ë' = "&euml;"
escape 'ì' = "&igrave;"
escape 'í' = "&iacute;"
escape 'î' = "&icirc;"
escape 'ï' = "&iuml;"
escape 'ð' = "&eth;"
escape 'ñ' = "&ntilde;"
escape 'ò' = "&ograve;"
escape 'ó' = "&oacute;"
escape 'ô' = "&ocirc;"
escape 'õ' = "&otilde;"
escape 'ö' = "&ouml;"
escape 'ø' = "&oslash;"
escape 'ù' = "&ugrave;"
escape 'ú' = "&uacute;"
escape 'û' = "&ucirc;"
escape 'ü' = "&uuml;"
escape 'ý' = "&yacute;"
escape 'þ' = "&thorn;"
escape 'ÿ' = "&yuml;"
escape x = [x]
