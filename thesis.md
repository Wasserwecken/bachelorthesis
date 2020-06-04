# Begrifferklärung
- Material
- Materialeigenschaft
- Textur
- Prozedural

# Einführung
## Problem
Viele Softwarelösungen im 3D Bereich bieten eine Shaderintegration, oft in Form eines Node-Systems, an. Durch diese Integration ist es möglich prozedurale Texturen mithilfe eines Fragment-Shader zu erzeugen.

Allerdings ist ein strukturiertes Vorgehen nicht gegeben, und jede Software bringt eingene ergänzende Funktionalitäten mit sich die den Workflow beeinflussen können. Diese Funktionalitäten sind aber das kernelment von prozeduralen Texturen.

Das erstellen von prozedural Texturen konzerntriert sich darauf, bestehende komplexe Algorithmen miteinander zu verbinden und oder deren Parameter anzupassen. Die benötigten Funktionalitäten sind allerdings nicht in jeder Lösung zu finden und müssen daher selbt implementiert werden.


Das erstellen von prozeduralen Texturen erfordert Erfahrungen und Wissen, welches sich meist durch Training und Experiment angeeigt wird.

## Ziel
Das Ziel dieser Arbeit ist es einen allgemein gültigen, strukturierten Workflow zu finden. Auch soll analysiert werden welche Funktionalitäten essentiel sind und wie diese Verwendung finden können.


## Lösung
Ein Workflow soll ausgearbeitet werden welcher auf jede Textur anwendbar und nachvollziehbar ist. Funktionalitäten sollen Kategorisiert und die Anwendungen definiert werden.

## Testbarkeit
* ???


# Prozedurale Materialien
Der Prozess zum erstellen von prozeduralen Materialen umfasst verschiedene Teilbereiche. Diese fallen je nach gefordertem Material intensiver aus oder gar weg. Um die Abfolge und Relevanz einordnen zu können wird der ganze Prozess in zwei Hauptphasen eingeteilt:
- Analyse
- Umsetzung

Die Analyse dient dazu alle relevanten Informationen und Referenzen für das neue Material zu sammeln, verarbeiten und in abstrahierten Form wiedergeben zu können. Die Analyse ist die erste Pase die durchlaufen werden muss.

Die Umsetzung besteht darin Algorithmen und deren Parameter zu kombinieren und layern. Dabei entstehen Texturen als Ergebnis die die Eigenschaften des Materials repräsentieren.

Der gesammte Prozess kann dabei sowohl komplex als auch simpel ausfallen. Eintscheident ist der geforderte Detailgrad. Ein fotorealistisches Material erfordert eine deutlich intensivere Analyse und komplexere Umsetzung, als ein Low-Poly Material. Dieses kann im Extreamfall einen einzelnen Farbwert als einzelne Eigenschaft besitzen. Der Detailgrad kann dabei von viele Faktoren abhängen. Als Beispiel könnte Entfernung und Style-Giudeline entscheident sein. Wie sich der Detailgrad zusammensetzt ist nicht für diese Arbeit, er bestimmt aber die Relevanz für alle Ausführungen in der Workflow-Definition.


# Umsetzung
Um ein Material strukturiert Umzusetzen muss definiert werden wie Algorithmen kategorisiert werden können um diese als Techniken zu verwenden können. Als Kategorien für Algorithmen werden folgende definiert:
- Random
- Noise
- UV
- Shapes
- Easing

Um die definierten Kategorien sinnvoll Einzusetzten muss Entwicklungsprozess der Umsetzung näher betrachtet werden.


## Kategorien
Die Kategorien leiten sich ab durch... ???
Die Kategorien dienen zur Einordnung der anwendung der darunter liegenden Algorithmen. Die Algorithmen selbst können dabei selbst gewählt werden. Einzelne Algorithmen zu definieren würde den Rahmen der Arbeit überschreiten und einen allgemein gültigen Workflow verhindern.

### Random


### Noise
### UV
### Shapes
### Easing




## Entwicklungsprozess









# Analyse



# Vorbereitung
Die Vorbereitung soll abstrakt herrausarbeiten welche Techniken und Algorithmen bei der Umsetzung angewendet werden können. Das führt dazu zu schnellen ersten Ergebnissen und unnötige Trial-And-Error Phasen werden minimiert. Um eine gewünschte Textur zu abstrahieren müssen Referenzen und Informationen aus zwei Blickwinkel betrachtet werden. Aus der Sicht von:
- Material
- Komposition

Das ist notwendig um zum einen eine WIederverwendbarkeit von erstellten Texturen und Teilumsetzungen zu ermöglichen, aber auch werden teilweise unterschiedliche Techniken für Materialien und Komposition verwendet.
Der erste Schritt ist herrauszuarbeiten welche Materialien in der zu erstellenden Textur verwendet werden, und wie sie aufgeteilt werden. Am Beispiel einer einfachen Mauer sind die zu erkennenden Materialien Stein und Mörtel. Die Komposition wird bestimmt durch die Steinform und der Mörtel füllt die Lücken aus.


## Materialien
Die Eigenschaften eines Materials werden durch verschiedene Faktoren bestimmt. Diese können für jedes Material individuel ausfallen. Einige Faktoren









Materialien müssen deshalb verstanden werden, da ein Material seine Optik und EIgenschaften in unterschiedlichen weisen repräsentieren kann. Wie ein Material
sich allerdings darsellt hängt von verschiedenen Faktoren ab.

### Interne
Als intern können Faktoren gesehen werden die das Material ausschließlich selbst betreffen. Wie z.b. die Art der Produktion und oder Entstehung. Als Beispiel Holz: Jede Holzart eigene visuele Merkmale als auch teilweise einschlägige Farbtöne. Auch lässt sich durch die Analyse der Entstehung die charakteristischen Farbabstufungen im Holz durch die Jahresringe und ausgehende Äste erklären. Das ist deshalb interesant da ein gesägtes Brett gleich einem Querschnitt steht. Ein Querschnitt in einer 3D Noise kann teilweise erwünschte Resultate erziehlen.

### Externe
Externe Faktoren sind all jene Umstände und Informationen welche nicht direkt im Zusammenhang mit dem Material stehen sondern durch die Umgebung bestimmt sind. So kann 


## Komposition