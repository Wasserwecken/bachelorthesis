<!-- ########################################## -->
# Einführung
## Prozedurale Texturen
* Was bedeuted prozedural
* Welche Vorteile bietet das
* Non destructual Workflow
* Mehrere Texturen für eine Oberfläche (PBR)

## Fragment Shader
* Wie funktionert ein Fragment Shader

## Problem
* 

## Ziel
* 

## Lösung
* 


<!-- ########################################## -->
# Analyse

## Bedarf
* Wie weit ist die Oberfläche vom Sichtpunk entfernt?
* Wie viel Detail ist vom Projekt gefordert

## Kontext
* Wo findet man die Oberfläche? Im Freien / Im Wald / etc.
* Welche Einwirkungen, Merkmale beschädigungen können dadurch auftreten
* Wie alt ist die Oberfläche?

## Komposition
### Trennung in einzelne Oberflächen
* Aus welchen Materialien setzt sich die Oberfläche zusammen.
* Liegt etwas auf der Oberfläche zusätzlich drauf (Staub, Blätter, Kratzer).
* Liegen Beschädigungen vor?
* Haben die einzelnen Komponenten einen Zusammenhang?

### Analyse der Materialien der Oberfläche
* Welche eigenschaften hat das Material?
* Wie setzt es sich im Volumen zusammen
* Wie entsteht es?

### Mustererkennung
* Sind regelmäßige Muster wie Kacheln oder Formen zu erkennen.
* Erst grobe Strukturen analysieren dann immer Feiner werden.
* Sind Muster in Muster zu erkennen?
* Welche Muster treten häufig auf.
* Welche Formen treten häufig auf.
* Gibt es erkennbare Verzerrungen?

### Höhenverteilung
* Warum ist es wichtig die Höhe zu kennen.
* Welche Muster sind in der Höhe zu erkennen
* Wie ist die Höhenverteilung der Oberfläche.
* Hat die Höhe einfluss auf die Verteilung von den Materialien?


<!-- ########################################## -->
# Erstellen der Textur
## Vorgehen
* Mit der Höhe beginnen.
* Denken in Layern.
* Mit dem unterstem Material beginnen.
* Ins Detail iterieren.

## Zufall
* Noise arten
* Fractal Browning Motion
* Zufallsbestimmung
* Einfluss des Zufalls in der Natur / Realität

## Seed
* Was ist das?
* Wozubraucht man das?

## UV als Leinwand
* Wiederverwndbarkeit
* Manipulation der UV

## Masking
* Wie können Patterns und Formen als Masken eingesetzt werden?
* Wie kann man Masken ableiten?

## Unvollkommenheit
* Wieso sehen perfekte Oberflächen nicht gut aus.

## Kombination von Formen
* Wie können komplexe Formen aus simplen zusamengesetzt werden.

## Kombination von Formen und Pattern
* Wie können Formen regelmäßig wiederholt werden
* Wie können Formen mit patterns ergänzt und manipuliert werden.

## Easing
* Welche Freiheiten ergeben sich?
* Welche Formen gibt es?
* Welche Manipulationen ergeben sich

## Kombinieren von Layern / Materialien
* Welchen zweck haben Masken.
* Wie kann man Masken ableiten.

## Iterieren
* Von Grob zu fein.
* Wie teilt man Grob und fein ein.

## Höhe als ausgang für andere Texturinfos
* Welche einflüsse kann die Höhe haben.
* Höhe als Maske.




<!-- ########################################## -->
# Framework base
## Value processing
## UV manipulations
## Noises
## Easing
## Tiling