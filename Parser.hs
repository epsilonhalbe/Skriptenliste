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
parseMSemester = (do char 'W'
                     many (noneOf "_")
                     return $ Just WS) <|>
                 (do char 'S'
                     many (noneOf "_")
                     return $ Just SS) <|>
                 (do many (noneOf "_")
                     return Nothing)

parseMTyp :: Parser (Maybe Typ)
parseMTyp = (do char 'L' <|> char 'l'
                char 'A' <|> char 'a'
                char 'T' <|> char 't'
                char 'E' <|> char 'e'
                char 'X' <|> char 'x'
                many (noneOf "_")
                return $ Just LaTeX) <|>
            try (do char 'M' <|> char 'm'
                    string "anuskript"
                    many (noneOf "_")
                    return $ Just Manuskript) <|>
            (do char 'M' <|> char 'm'
                string "itschrift"
                many (noneOf "_")
                return $ Just Mitschrift) <|>
            try (do char 'V' <|> char 'v'
                    char 'O' <|> char 'o'
                    many (noneOf "_")
                    return $ Just Mitschrift) <|>
            (do char 'V' <|> char 'v'
                char 'U' <|> char 'u'
                many (noneOf "_")
                return $ Just VU) <|>
            (do char 'U' <|> char 'u' <|> char 'Ü' <|> char 'ü'
                string "ebung" <|> string "bung"
                many (noneOf "_")
                return $ Just Übung) <|>
            (do char 'P' <|> char 'p'
                char 'r'
                string "uefung" <|> string "üfung"
                many (noneOf "_")
                return $ Just Prüfung) <|>
            (do char 'K' <|> char 'k'
                string "oll"
                many (noneOf "_")
                return $ Just Prüfung) <|>
            (do many (noneOf "_")
                return Nothing)

parseMJahr :: Parser (Maybe Jahr)
parseMJahr = (do n <- many1 digit
                 return . Just . J $ read n) <|>
             (do many1 (noneOf "_")
                 return Nothing)
