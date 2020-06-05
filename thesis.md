# Begrifferklärung
- Material
- Materialeigenschaft
- Textur
- Prozedural

# Einführung
## Problem
Viele Arbeiten die sich mit dem Thema prozedurale Textur generierung beschäftigen haben bereits die Bedetung, Entwicklung und Verwendungszwecke von Algorithmen untersucht. Allerdings ist es nachwievor nicht leicht zu erkennen wie Algorithmen und Techniken zusammenspielen müssen um ein bestimmtes Ergebnis in Form eines prozeduralen Materials zu bekommen. Hier setzt diese Arbeit an.

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


# Übersicht
- Analyse
    - Material
    - Komposition

- Umsetzung
    - Algorithmen
        - Noise
        - UV
        - Shapes
        - Easing

    - Techniken
        - Höhe zurest
        - Masking
        - Layering
        - Manipulation




# Prozedurale Materialien
Ein Material für einen Shader besteht in den meisten Fällen nicht aus einer einzelnen Textur. So wie ein Shader verschiedene Eigenschaften für seine Verarbeitung besitzt kann ein Material diese steuern um die gewünschte optische Erscheinung zu erreichen. Nimmt man als Beispiel einen Phong-Shader, weißt dieser drei Eigenschaften auf: Diffuse Color, Specular Color und Shininess. Eine PBR-Shader implementation hat wiederum andere Eigenschaften die gesteuert werden können. Ein Material in Form einer Textur besteht also aus mehren Texturen die diese Eigenschaften steuern.

Eine prozedurales Material innerhalb eines Fragment-Shader muss auch die Eigenschaften des Shader steuern. So entsteht bei einem prozeduralen Material als gesamtes Ergebnis mehrere Teilergebnisse die mit Texturen gleichgesetzt werden können.

Um den Prozess des Erstellens von einem prozeduralen Material zu definieren, wird dieser in seine einzelnen Teilprozesse zerlegt. Als Einstieg dient dabei die klassische Unterteilung in: Analyse und Umsetzung.

Diese Teilprozesse stehen nicht für sich selbst geschlossen dar und können mehrmals im Verlauf einer Entwicklung durchlaufen werden. Sie hängen beide dennoch voneinander ab. Die Analyse muss Informationen und Referenzen so aufarbeiten und abstrahieren das diese auf die Möglichkeiten der Umsetzung angepasst sind. Die Umsetzung muss natürlich die aufbereiteten Informationen implementieren.

Durch die Abhängigkeit der Analyse zur Umsetzung wird in dieser Arbeit die Umsetzung zuerst behandelt. Bei der Ausführung des Prozesses sollte die Analyse immer vor der Umsetzung durchgeführt werden.

Eine zusätzliche essentiell übergreifende Information die in jedem Teilprozess zum tragen kommt ist der geforderte Detailgrad eines prozeduralen Materials. Dieser Detailgrad bestimmt wie intensiv Teilprozesse durchlaufen müssen, oder welche nicht benötigt werden. Welche Teilprozesse wie davon betroffen sind, muss der Anwender selbst entscheiden. Ein Beispiel: Ein fotorealistisches PBR Material benötigt eine deutlich intensivere Analyse und komplexere Umsetzung als ein Phong Low-Poly Material, welches im Extremfall einen einzelnen Farbwert als einzige Eigenschaft besitzen. Woran sich der geforderte Detailgrad ableitet ist nicht Teil dieser Arbeit, wichtig ist aber diesen zu kennen.




# Umsetzung
Für die implementation eines prozeduralen Materials ist es wichtig zu wissen welche technische und künstlerische Möglichkeiten durch einen Fragment-Shader zu Verfügung stehen. Dabei muss zwischen Algorithmen und Techniken unterschieden werden. Techniken definieren sich durch das geschickte kombinieren von Algorithmen um optische Modifikationen oder Eigenschaften zu erreichen. Algorithmen bilden wiederum atomare Bausteine auf die eine prozedurale Textur aufbaut. Ähnlich vergleichbar mit einem Lego Spiel.



## Algorithmen
Wie bereits erwähnt stellen Algorithmen atomare Bausteine für ein prozedurales Material dar. Die Bausteine selbst können Parameter definieren um ihr Verhalten zu steuern, sind aber über jedes Material hinweg gleich. Durch die atomare Definition kann eine Bibliothek aufgebaut werden.


### Noise
Bla


### UV
Bla


### Shapes
Bla


### Easing
Bla























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