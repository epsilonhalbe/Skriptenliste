# Skriptensammlung

Ist ein Programm zum Managen der Skriptensammlung der Studienrichtungsvertretung
<=Roter Vektor=.

Dies ist mein erster Versuch mit GUI design insbesondere mit "threepnny-gui".
Die Funktionsweise ist so dass ein gegebener Folder (default "~/Skriptensammlung")
nach pdfs durchsucht wird und alle pdfs die nach dem Schema

    Autor_Titel_Typ_Semester_Jahr.pdf

benannt sind nach Autor sortiert und gruppiert, wobei

 - Typ = Latex oder Mitschrift
 - Semester = W oder S

Skripten die _nicht_ diesem Format entsprechen werden am Anfang gereiht und rot
dargestellt.

Lizenz: BSD3
Autor: Martin Heuschober
Credits: HeinrichApfelmus für threepenny-gui
