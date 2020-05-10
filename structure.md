<!-- ########################################## -->
# Begrifferklärung
* Prozedural
* Non destructual Workflow
* mehere Texturen für ein Material
* Fragmentshader

# Einführung
## Problem
* Kein allgemeines Vorgehen bekannt
* Jede Software hat eigene Funktionalitäten
* Noises / Formen / etc können kompliziert sein

## Ziel
* Einfachen Workflow finden
* Worflow soll die meisten Materialien abdecken können

## Lösung
* Kleines Framework
* Worflow beschreiben

## Testbarkeit
* ???



<!-- ########################################## -->
# Analyse
* Wie nimmt man ein Material auseinander.
* Wie sammelt man seine Anforderungen.

## Bedarf
* Sichtbarkeit der Oberfläche
* Entfernung der Oberfläche
* Generelle Anforderung ans Detail

## Kontext
* Wo findet man die Oberfläche? Im Freien / Im Wald / etc.
* Welche Einwirkungen, Merkmale beschädigungen können dadurch auftreten
* Wie alt ist die Oberfläche?

## Komposition
### Trennung der Oberfläche in einzelne Materialien
* Aus welchen Materialien setzt sich die Oberfläche zusammen.
* Liegt etwas auf der Oberfläche zusätzlich drauf (Staub, Blätter, Kratzer).
* Liegen Beschädigungen vor?
* Haben die einzelnen Komponenten einen Zusammenhang?

### Analyse der Materialien
* Welche eigenschaften hat das Material?
* Wie setzt es sich im Volumen zusammen
* Wie entsteht es?

### Mustererkennung
* Sind regelmäßige Muster wie Kacheln oder Formen zu erkennen.
* Erst grobe Strukturen analysieren dann immer Feiner werden.
* Sind Muster in Muster zu erkennen?
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
* Manipulation der UV vs Form

## Unvollkommenheit
* Wieso sehen perfekte Oberflächen nicht gut aus.

## Kombination von Formen
* Wie können komplexe Formen aus simplen zusamengesetzt werden.
* Formen für Masking

## Kombination von Formen und Pattern / Noise
* Wie können Formen regelmäßig wiederholt werden
* Wie können Formen mit patterns ergänzt und manipuliert werden.

## Easing
* Welche Freiheiten ergeben sich?
* Welche Formen gibt es?
* Welche Manipulationen ergeben sich

## Iterieren
* Von Grob zu fein.
* Wie teilt man Grob und fein ein.

## Kombinieren von Layern / Materialien
* Welchen zweck haben Masken.
* Wie kann man Masken ableiten.

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