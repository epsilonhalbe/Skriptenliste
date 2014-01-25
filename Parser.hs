module Parser where

import Text.Parsec
import Text.ParserCombinators.Parsec hiding (try)

import Data

skriptum :: String -> Either ParseError Skriptum
skriptum s = parse parseSkriptum s s

parseSkriptum :: Parser Skriptum
parseSkriptum = do a <- parseAutor
                   char '_'
                   ti <- parseTitel
                   char '_'
                   ty <- parseMTyp
                   char '_'
                   tm <- parseMSemester
                   char '_'
                   y <- parseMJahr
                   return $ Skriptum a ti tm y Nothing ty

parseTitel :: Parser String
parseTitel = many1 (noneOf "_")

parseAutor :: Parser String
parseAutor = many1 (noneOf "_")

parseMSemester :: Parser (Maybe Semester)
parseMSemester = try (do char 'W'
                         return $ Just WS) <|>
                 try (do char 'S'
                         return $ Just SS) <|>
                 return Nothing

parseMTyp :: Parser (Maybe Typ)
parseMTyp =  (do choice [string "Latex", string "LaTeX", string "latex"]
                 return $ Just LaTeX) <|>
             (do choice [string "Mitschrift", string "mitschrift"]
                 return $ Just Mitschrift) <|>
                 return Nothing

parseMJahr :: Parser (Maybe Jahr)
parseMJahr =  (do n <- many1 digit
                  return . Just . J $ read n) <|>
              return Nothing
