
# Begriffserklärungen
In der Computergrafik begegnet man immer wieder Ausdrücken und Wörtern die ähnlich klingen und auch ähnliches behandeln. Hier soll nochmal die Definition einzelner Ausdrücke wiederholt werden, aber auch neue Definitionen hinzugefügt werden. Diese sind für die nachfolgende Arbeit wichtig, da auf die kleinen Unterschiede eingegangen wird.


## Surface-Shader
Ein Shader ist ein Programm das meist auf der GPU läuft um die Schattierung und Farbgebung eines Objektes, sowohl 2D oder 3D, festzulegen. Dabei können Parameter für das shading von außen gesetzt, aber auch selbst generiert werden.

Als Surface-Shader bezeichnet man Algorithmen, die Berechnungen für Lichteinfall und teilweise Verformungen der Oberfläche übernehmen. Surface-Shader werden über Materialien hinweg wiederverwendet und nur durch ihre Parameter gesteuert.


## Material
Ein Material besteht aus einem Zusammenschluss von Informationen die für die Parameter eines Surface-Shader benötigt werden. Ein Material kann sowohl ein Zusammenschluss von mehreren Materialien sein, als auch für sich alleine stehen. Letztendlich bedient aber immer nur ein Material einen Surface-Shader.


## Textur
Eine Textur ist eine Zwei-Dimensionale Abbildung von Farbwerten. Materialien bestehen oft aus mehreren einzelnen Texturen die die Parameter eines Surface-Shader bedienen.


## Prozedurale Textur
Eine von vielen Definitionen für den Ausdruck "prozedurale Textur": "A procedural texture is a computer-generated image created using an algorithm
(this is where the term procedural is derived from: a procedure is driving the
process), instead of a digital painting or image processing application[...]" [(D01)].

Prozedurale Texturen stellen einen expliziten Verarbeitungsprozess innerhalb eines Surface-Shader für Informationen dar. Explicit deshalb, da die Informationen vor dem Auswerten des Surface-Shader bereits feststehen [(EMP01)], [(D01)]. Die Erstellung einer Textur kann aber implizit erfolgen.

## Prozedurales Material
Als prozedurales Material ist ein Algorithmus der nicht nur eine einzelne Oberflächen-Eigenschaft beschreibt oder Surface-Shader-Parameter bedient. Ein prozedurales Material liefert für eine Oberfläche alle nötigen Informationen für einen Surface-Shader die passend zusammenspielen und zusammenhängen.

## Prozedurales Shader Material
Ein Material das als Shader implementiert ist, bildet einen impliziten Prozess ab. Es wird dabei ein immer nur ein einzelner Punkt des Materials ausgewertet. Bei der Auswertung besteht keine Abhängigkeit zu Nachbarpixel oder Fragmente. Dies hat einige Einflüsse auf die technische Möglichkeiten, Informationen für die Parameter eines Surface-Shader zu generieren.

So entsteht bei einem prozeduralen Material als gesamtes Ergebnis mehrere Teilergebnisse die mit Texturen gleichgesetzt werden können.



# Einführung
In der Vergangenheit haben viele Arbeiten bereits verschiedene Algorithmen als Grundlage für prozedurale Texturen hervorgebracht [(LLC01)],[(P01)],[(W01)],[(EMP01)]. Sie haben ausführlich die Bedeutung, Entwicklung und Verwendungszwecke behandelt und damit die Computergrafik nachhaltig geprägt. Viele dieser Algorithmen können parallelisiert und so abstrahiert werden um in Fragment-Shader Anwendung zu finden [(G01)]. Zusätzlich bieten viele Grafik-Programme eine Schnittstelle, meist in Form eines Node-System, zu Fragment- und Vertex-Shader 
[(BLE01)],[(MAY01)],[(UNI01)],[(UNR01)]. Dies ermöglicht nicht nur Einfluss auf das Shading der Scene und Objekte zu nehmen, sondern auch auf die Texturierung. Zusätzlich bieten diese Applikationen fertige implizite Implementierungen von Algorithmen für ihre Schnittstellen. Diese sind so abstrahiert das diese wie Bausteine verwendet werden können. Durch das kombinieren von Algorithmen, bzw. Bausteinen, können so eindrucksvolle prozedurale Materialen erstellt werden, die keine Abhängigkeiten zu Texturen besitzen.


## Problem
Der Prozess, eine prozedurales Material zu erstellen, kann aufwendig und komplex sein der unter vielen Einflüssen und Abhängigkeiten steht. Dem Anwender steht hier die Welt mit all ihren Möglichkeiten offen. Ohne Vorerfahrung, technisches Hintergrundwissen und oder strukturiertes Vorgehen kann es schwer sein gute Ergebnisse zu erzielen.

Dazu kommt das Applikationen mit Shader-Schnittstellen, bereits fertige Bausteine mit ausliefern. Applikationen benennen diese aber teilweise unterschiedlich, stellen unterschiedliche Parameter zur Steuerung bereit oder bieten nur einige oder keine Bausteine an.


## Ziel der Arbeit
Durch die Definierung eines Workflows und seiner Teilprozesse wird ein Applikation übergreifendes strukturiertes Vorgehen möglich. Auch fehlende Erfahrung kann damit ausgeglichen werden. Die Definition umschließt sowohl das sammeln an Informationen über eine Oberfläche, als auch die eigentliche Implementierung.

Durch eine Kategorisierung nach Verwendungszwecken und Art von Algorithmen wird ein Überblick geschaffen, der zeigt welche Art von Algorithmen nötig sind um prozedurale Materialien zu erstellen. Durch eine Definition von sich wiederholenden Techniken die den Umgang und Kombination von Algorithmen beschreiben kann auch die Verwendung standarisiert werden.



# Und Los
Um den Prozess des Erstellens von einem prozeduralen Material zu definieren, wird dieser in seine einzelnen Teilprozesse zerlegt. Als Einstieg dient dabei die klassische Unterteilung in: Analyse und Umsetzung.

Diese Teilprozesse stehen nicht für sich selbst geschlossen dar und können mehrmals im Verlauf einer Entwicklung durchlaufen werden. Sie hängen beide dennoch voneinander ab. Die Analyse muss Informationen und Referenzen so aufarbeiten und abstrahieren das diese auf die Möglichkeiten der Umsetzung angepasst sind. Die Umsetzung muss natürlich die aufbereiteten Informationen implementieren.

Durch die Abhängigkeit der Analyse zur Umsetzung wird in dieser Arbeit die Umsetzung zuerst behandelt. Bei der Ausführung des Prozesses sollte die Analyse immer vor der Umsetzung durchgeführt werden.

Eine zusätzliche essentiell übergreifende Information die in jedem Teilprozess zum tragen kommt ist der geforderte Detailgrad eines prozeduralen Materials. Dieser Detailgrad bestimmt wie intensiv Teilprozesse durchlaufen müssen, oder welche nicht benötigt werden. Welche Teilprozesse wie davon betroffen sind, muss der Anwender selbst entscheiden. Ein Beispiel: Ein fotorealistisches PBR Material benötigt eine deutlich intensivere Analyse und komplexere Umsetzung als ein Phong Low-Poly Material, welches im Extremfall einen einzelnen Farbwert als einzige Eigenschaft besitzen. Woran sich der geforderte Detailgrad ableitet ist nicht Teil dieser Arbeit, wichtig ist aber diesen zu kennen.




# Umsetzung
Für die implementation eines prozeduralen Materials ist es wichtig zu wissen welche technische und künstlerische Möglichkeiten durch einen Fragment-Shader zu Verfügung stehen. Dabei muss zwischen Algorithmen und Techniken unterschieden werden. Techniken definieren sich durch das geschickte kombinieren von Algorithmen um optische Modifikationen oder Eigenschaften zu erreichen. Algorithmen bilden wiederum atomare Bausteine auf die eine prozedurale Textur aufbaut. Ähnlich vergleichbar mit einem Lego Spiel.



## Algorithmen
Algorithmen stellen atomare Bausteine für ein prozedurales Material dar. Die Algorithmen selbst können Parameter definieren um ihr Verhalten zu steuern, sind aber über jedes Material gleich. 

Um die spezifische Aufgabe eines Algorithmus besser zu verstehen und eine Austauschbarkeit zu ermöglichen, werden diese nach Ihrer Aufgabe kategorisiert.


### Noise
Unter der Kategorie Noise können alle Algorithmen verstanden werden, welche als Ergebnis ein zufälliges variierendes regelmäßiges Muster erzeugen. Als Beispiel können WhiteNoise, Perlin-Noise, Fractal-Browning-Motion genannt werden.

Noise wird in prozeduralen Materialien verwendet um Imperfektion und natürliche Variation in Oberflächen zu bringen. So kann das Ergebnis eines Noise-Algorithmus als Höhenkarte oder Maske für andere Layer dienen.


### UV
Die UV ist in einem Fragment-Shader die Leinwand eines prozeduralen Materials.
Durch die Manipulation der Leinwand können zusätzliche Variationen und Effekte entstehen. Als einfachstes Beispiel dient Rotation und Frakturierung.
Durch ein anderes Mapping, z.B. auf Polar-Koordinaten können gewünschte optische EEigenschaften einfach erreicht werden.


### Shapes
Formen sind für Basis für komplexere Formen. Dadurch das in einem Fragment-Shader nicht auf Nachbarpixel zugegriffen werden kann, empfiehlt es sich für jede Form einen Blur-Parameter zu implementieren. Durch einen weichen Übergang an den Rändern können viele Effekte erreicht werden.


### Easing
Easing-Algorithmen werden meist beim manipulieren von Höhenkarten und Masken verwendet. Auch kann als Beispiel die Verteilung von WhiteNoise gesteuert werden.


### Mathematische Funktionen
Nicht alle Algorithmen oder Methoden können unter die anderen Kategorien eingeteilt werden. Manchmal sind diese einfach zu generisch und finden in jedem Bereich seine Anwendung. Nichts desto trotz gibt es Methoden die genauso wichtig sind um Werte zu brachen und manipulieren. 



## Techniken
Techniken beschreiben das allgemeine Vorgehen und Lösungsansätze für wiederkehrende Aufgaben und Probleme.


### Höhe als Grundlage
Die Höhe sollte in schwarz weiß dargestellt werden. Schwarz für die Tiefen als 0.0, Weiß für de Höhen als 1.0. Das hat den Vorteil dass das Ergebnis einfach für den AAnwender zu interpretieren ist. Auch ist die Performance von Floating-Point Operationen besser als wenn man mit einem Vektor arbeiten würde.
Viele Algorithmen können somit die Höhenwerte einfach und transparent verarbeiten.

Die Höhe ist deshalb als Grundlage wichtig, da viele visuelle Eigenschaften davon abgeleitet werden können. Es können Aufgrund der Höhe beispielweise Masken erstellt werden um andere Materialien miteinander zu verbinden. Auch die Verteilung von Schmutz und Gebrauchsspuren können mit einer Höhenkarte glaubhaft verteilt werden.

Ein weiterer Vorteil ist die Entstehung eines Non-Destruktiv-Workflows. Sprich da alles was in einem prozeduralen Material geschieht auf der Höhe basiert, kann diese im Nachhinein immer noch bearbeitet werden, ohne die Nachfolgende Arbeit zu zerstören. Die nachfolgende Logik wird auf die neue Höhenverteilung korrekt reagieren. 

Die Bearbeitung der Höhenkarte ist ein Prozess der sich fast bis zum Ende des Materials hindurchzieht.


### Blending
Durch das Kombinieren von Formen und oder Noise entstehen die gewünschten Merkmale eines Materials. Dies funktioniert wie in einer Bildbearbeitungs-Software. Die miteinander zu verbindenden Ergebnisse sind als Layer zu betrachten. Durch eine gegebene Maske können diese mit einer Blend-Logik miteinander verbunden werden. Dabei muss Blending nicht immer nur zwei eigenständige komplexe Ergebnisse miteinander verbinden. Es kann auch dazu genutzt werden um bestehende Ergebnisse leicht abzuwandeln.

Blending kann im ganzen Material Anwendung finden. Sowohl Höhen können manipuliert werden, als auch Farbwerte.


### UV-Manipulationen
Viele Ergebnisse der Algorithmen sind für sich stehend oft zu perfekt oder bieten nicht die Nötige Abwechslung und Merkmale. Durch die Manipulation der UV können diese aber so abgewandelt werden um das auszugleichen. Als Beispiel ein zertretener Kaugummi: Nimmt man einen Kreis, manipuliert seine UV mit einer Rotation die durch eine Noise gesteuert wird, können Unregelmäßigkeiten erzeugt werden.


### Natürliche Unregelmäßigkeit
Durch die Definierung eines Materials mit einer mathematischen Grundlage, entstehen so schnell Ergebnisse die nahe an Oberflächen aus der Realität erinnern, sind aber häufig zu perfekt. Als Beispiel eine geflieste Oberfläche:
Diese sieht bereits glaubhaft aus, kann aber noch weiter verbessert werden. So kann man all Kacheln zufällig um ein paar Grad drehen um den Menschlichen Fehler beim fließen zu simulieren. Zusätzlich können alle Kacheln um ein paar Grad geneigt werden. Eine weitere Noise steuert zuletzt die Kalkablagerung.

Festzuhalten ist, das keine Oberfläche perfekt ist. Eine Oberfläche ist immer äußeren Auswirkungen ausgesetzt. Die können je nach Material und Umgebung sehr unterschiedlich ausfallen. Bei der Analyse sollten diese aber erkannt werden. Ein Material kann somit deutlich an Glaubhaftigkeit und Realismus gewinnen.


### Seed
Bei der Entwicklung von mehreren prozeduralen Texturen hat sich gezeigt das die Verwendung eines Seed Überschneidungen und Korrelationen innerhalb von Teilergebnissen eines Materials vermieden werden können. Dies liegt daran, das es auf der Grafikkarte kein keinen persistierten Pseudozufallsgenerator gibt. Dieser muss zum einen selbst implementiert werden und mit mindestens einem Eingangswert aufgerufen werden. Um nun innerhalb von Teilergebnissen nicht immer eine magische Nummer statisch im Code verankern zu müssen, ist es Hilfreich bei Methoden die auf Zufall basieren einen Seed-Parameter mit zu implementieren. Dieser kann hierarchisch immer weiter gegeben werden und bei jeder Verwendung oder Weitergabe wird dieser inkrementiert oder verändert.



# Analyse
Die Analyse soll abstrakt herausarbeiten welche Techniken und Algorithmen bei der Umsetzung angewendet werden können. Das führt dazu zu schnellen ersten Ergebnissen und unnötige Trial-And-Error Phasen werden minimiert. Um eine gewünschte Textur zu abstrahieren müssen Referenzen und Informationen aus zwei Blickwinkel betrachtet werden. Aus der Sicht von Material und Komposition.

Das ist notwendig um zum einen eine Wiederverwendbarkeit von erstellten Texturen und Teilumsetzungen zu ermöglichen, aber auch werden teilweise unterschiedliche Techniken für Materialien und Komposition verwendet.
Der erste Schritt ist auszuarbeiten welche Materialien in der zu erstellenden Textur verwendet werden, und wie sie aufgeteilt werden. Am Beispiel einer einfachen Mauer sind die zu erkennenden Materialien Stein und Mörtel. Die Komposition wird bestimmt durch die Steinform und der Mörtel füllt die Lücken aus.


## Materialien
Eine Oberfläche für sich gesehen als ganzes hat bestimmte Merkmale und Eigenschaften die Einfluss auf die Erscheinung haben. Eine Vielzahl an unterschiedlichsten Faktoren können diese zusätzlich ändern oder neue Merkmale und Eigenschaften hinzufügen. Um eine Oberfläche glaubhaft als prozedurales Material abzubilden ist es wichtig sich mit den Eigenschaften und Merkmalen, die sowohl vom Material selbst als auch durch Einflüsse gegeben sind, zu analysieren. Als Beispiel: Holz. Sowohl die Holzart selbst als auch die Verarbeitung hat gravierende Auswirkung auf die Erscheinung. Fügt man nun Faktoren wie Alter und Abnutzung hinzu ändert sich sich das Bild der Oberfläche noch einmal drastisch. Durch die Interpretation und Verständnis solcher Merkmale und Eigenschaften in prozeduralen Materialien können Charakter, Storytelling und Glaubwürdigkeit vermittelt werden. Um die Faktoren zu ermitteln welche entscheidend für ein Material sind können Faktoren in Interne und Externe eingeteilt werden. Dabei muss Festgehalten werden das jegliche Analyse die sich um ein Material dreht sich auch nur auf jenes bezieht. Dies darf nicht mit äußeren Faktoren wie Ablagerungen verwechselt werden. Diese sind als eigenes Material zu betrachten. Für das gesamte Material wird hier eine Komposition aus mehreren zusammenspielenden Materialiens erstellt.


### Interne
Interne Faktoren bestimmen Eigenschaften und Merkmale die losgelöst von äußeren Einflüssen sind. Diese Faktoren bestimmen die grundsätzliche Erscheinung einer Oberfläche und sind losgelöst von äußeren Einflüssen. Natürlich muss die Zusammensetzung eines Materials nicht endlos Tief betrachtet werden. Hier sollte auf den bereits genannten Detailgrad geachtet werden. Auch spielt die Prägnanz der Merkmale und Eigenschaften eine Rolle. Zudem müssen erfasste Merkmale nicht realitätsgetreu umgesetzt werden. Außerdem kann die Oberfläche als Querschnitt eines Materials gesehen werden. So kann eine 3D Noise welche auf 2D abgebildet wird möglicherweise schnell zu einem Ergebnis führen, da dies genauso einem Querschnitt entspricht.

### Externe
Externe Faktoren sind all jene Umstände und Informationen welche von der Umgebung abhängen. Wie bereits erwähnt ist keine Oberfläche perfekt und unberührt. Durch diese Faktoren entsteht die eigentliche Glaubwürdigkeit und der Charakter eines Materials. Als Einflüsse können Alter und Abnutzung aufgezählt werden. Die meisten Faktoren können aber zwischen Ablagerungen, chemische Reaktionen und physische Einwirkungen unterteilt werden. Welche Faktoren und in welchem Umfang zutreffen muss für jede Textur und Umgebung neu ermittelt werden.


## Komposition
Viele Oberflächen bestehen meistens nicht nur aus einem uniformen Material. In der Realität bestehen Oberflächen aus überlagerten oder zusammengesetzten Materialien. Auch kann eine Komposition durch äußere Einflüsse entstehen, die auf den gleichen externen Faktoren der Material-Analyse basieren. Ein Beispiel: Rostendes Metall. Hier verändert ein chemischer Prozess die Oberfläche so, das aus Metall ein Oxid mit komplett eigenen Eigenschaften und Merkmalen wird. Durch das Blenden dieser zweier Materialien entsteht am Ende eine überzeugende Komposition. Die Komposition beschränkt sich aber nicht nur auf das überlagern von Materialien um ein Uber-Material zu erzeugen. Als Oberfläche können auch Mauern gesehen werden die auf ganz natürlicherweise aus mehreren Materialien zusammengesetzt werden.



# Literatur
[(LLC01)]: https://lirias.kuleuven.be/retrieve/126051
> [(LLC01)]: *A survey of procedural noise functions* | 2010 | A. Lagae, S. Lefebvre, R. Cook, T. DeRose, G. Drettakis, D.S. Ebert,
J.P. Lewis, K. Perlin, M. Zwicker

[(P01)]: https://dl.acm.org/doi/pdf/10.1145/325165.325247
> [(P01)]: *An image synthesizer* | 1985 | Ken Perlin

[(P02)]: https://www.csee.umbc.edu/~olano/s2002c36/ch02.pdf
> [(P02)]: *Noise hardware* | 2001 | Ken Perlin

[(W01)]: https://dl.acm.org/doi/pdf/10.1145/237170.237267
> [(W01)]: *A Cellular Texture Basis Function* | 1996 | Steven Worley

[(G01)]: http://www.diva-portal.org/smash/get/diva2:618262/FULLTEXT02
> [(G01)]: *Procedural Textures in GLSL* | 2012 | Stefan Gustavson

[(B01)]: https://disney-animation.s3.amazonaws.com/library/s2012_pbs_disney_brdf_notes_v2.pdf
> [(B01)]: *Physically-Based Shading at Disney* | 2012 | Brent Burley

[(EMP01)]: https://www.google.com/search?q=Texturing+%26+modeling%3A+a+procedural+approach&oq=Texturing+%26+modeling%3A+a+procedural+approach&aqs=chrome..69i57j69i65j69i60l3.646j0j7&sourceid=chrome&ie=UTF-8
> [(EMP01)]: *Texturing & modeling: a procedural approach* | 2003 | David S Ebert, F Kenton Musgrave, Darwyn Peachey, Ken Perlin, Steven Worley

[(BLE01)]: https://docs.blender.org/manual/en/latest/render/shader_nodes/index.html
> [(BLE01)]: *Blender Shader Nodes* | 2020 | Blender Foundation

[(MAY01)]: https://knowledge.autodesk.com/support/maya/learn-explore/caas/CloudHelp/cloudhelp/2019/ENU/Maya-LightingShading/files/GUID-62DAABF0-299A-4F40-894D-C8FCACD1C046-htm.html
> [(MAY01)]: *Maya Texture Nodes* | 2020 | Autodesk

[(UNI01)]: https://unity.com/de/shader-graph
> [(UNI01)]: *Unity ShaderGraph* | 2020 | Unity Technologies

[(UNR01)]: https://docs.unrealengine.com/en-US/Engine/Rendering/Materials/Editor/index.html
> [(UNR01)]: *Unreal Material Editor* | 2020 | Epic Games

[(D01)]: https://www.researchgate.net/publication/314637042_The_New_Age_of_Procedural_Texturing
> [(D01)]: *The New Age of Procedural Texturing* | 2015 | Dr S´ebastien Deguy