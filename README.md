# Skriptensammlung

Ist ein Programm zum Managen der Skriptensammlung der Studienrichtungsvertretung
<=Roter Vektor=.

## Synopsis

Dies ist mein erster Versuch mit GUI design insbesondere mit "threepnny-gui".
Die Funktionsweise ist so dass ein gegebener Folder (`static/Skriptensammlung`)
nach pdfs durchsucht wird und alle pdfs die nach dem Schema

    Autor_Titel_Typ_Semester_Jahr.pdf

benannt sind nach Autor sortiert und gruppiert, wobei

 - Typ = Latex, Mitschrift, Manuskript, Prüfung/Koll, Übung oder VU
 - Semester = W oder S

Skripten die *nicht* diesem Format entsprechen werden am Anfang gereiht und rot
dargestellt.

## Usage

    > git clone https://github.com/epsilonhalbe/Skriptenliste.git
    > cd Skriptenliste
    > ln -s ~/meineskriptensammlung static/Skriptensammlung
    > ./Skriptenliste &
    > open browser at adress localhost:10000
    > search "string" in search form
    > click on desired file

## Autor, Lizenz und Credits

Lizenz: BSD3
Autor: Martin Heuschober
Credits: HeinrichApfelmus für threepenny-gui
