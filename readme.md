> # GENERATION OF PROCEDURAL MATERIALS WITHIN FRAGMENT-SHADER


# Abstract
...

# Prerequisites
This work requires basic understanding for fragment shaders.

# Introduction
Procedural texturing always has been a subject in computer graphics. Researchers sought for algorithms and improvements to synthesize textures to represent natural looking surfaces. Early algorithms as Perlin-Noise [(P01)] or Worley-Noise [(W01)] are still present today and essential for procedural texture generation, due to their appeareance which suits replicating natural properties.

![alt][NOISE01]
> *Images from papers. Left: Perlin noise [(P01)], Right: Worley noise [(W01)]*

In the early ages of procedural texture generation, algorithms and renderers where executed on the CPU. But now, "With the ever increasing levels of performance for programmable shading in GPU architectures, hardwareaccelerated procedural texturing in GLSL is now becoming quite useful[...]" [(G01)]. Imlicit algorithms, where a query for information about a arbitrary point is evaluated, suiting perfectly the conditions for fragment shaders, because it's task is to return the color of a arbitrary pixel without knowledge about it's neighbors [(K01)]. Some Algorithms like Perlin-Noise already defined implicit. Other Algorithms may need some modifications to be used imclicit, e.g. rendering shapes, where distance fields can be used to represent them implicit [(IQ02)], [(IQ03)]. But as concluded in the quoted paper from Gustavson: "[...] modern shader-capable GPUs are mature enough to render procedural patterns at fully interactive speeds [...]" [(G01)].

Today, a variety of modern 3D applications like  "Blender" [(BLE01)], "Unity 3D" [(UNI01)], "Unreal Engine" [(UNR01)] or "Cinema 4D" [(CIN01)] offering a interface to the attached renderer to handle the shading of objects in a modular manner, as proposed in the paper "shade trees" [(C01)]. While these interfaces enabling modifications to shading, it also enables generating procedural informations, because they work and behave like a fragment shader.
These interfaces already take advantage of this architecture and shipping with a variety of predefined algorithms to hide the complexity of those, like noise generation or UV projection. The posibilities of these interfaces can been pushed so far that convincing and abstract Surfaces can be created with them, without dependecies to textures or other external references.

![alt][NODEV01]
> *Procedural Materials in Blender, created for "Nodevember" with a sphere as base; By Simon Thommes 2019*

## Annotation
By dealing with render applications, procedural texture generation and shaders, some terms can have a similar meaning and sound. Therefore important terms have to be defined to prevent misunderstandings.

### Procedural
The paper "A Survey of Procedural Noise Functions" gave following definition:
"The adjective procedural is used in computer science to distinguish entities that are described by program code rather than by data structures. Procedural techniques are code segments or algorithms that specify some characteristic of a
computer-generated model or effect." [(LLC01)]

### Texture
Textures are images where a single or more informations about surface properties can be stored. Combined with the definition for "procedural", procedural textures are defined as: "A procedural texture is a computer-generated image created using an algorithm [...], instead of a digital painting or image processing application[...]" [(D01)]

### Material
TODO: Ich möchte hier die Bereiche von einem Material abdecken. Innerhalb von Engines wird ein Material als zusammenschluss aus Oberflächen informationen und Surface-Shader betrachtet. Aus meiner Sicht möchte ich aber das Wort Materials nur auf Oberflächen-EIgenschaften eingrenzen, da diese auch in anderen Surface-Shader verwendet werden können.

![alt][PBRNPR]
> *Unterschiedliche Surface-Shader mit gleichem Material und Mesh. Links: PBR, Rechts: NPR*



## Motivation
While its possible to use and layer multiple algorithms in shader and interfaces of various applications, creating convincing procedural materials can be a tidious and complex task. Manipulating results of algorithms in the right manner relies on repetitive tasks and practical knowledge to get convincing results. While there many possibilities and freedom for manipulations and choice of algorithms, shader and interfaces will not enfoce or guide creators to a workflow of creating procedural materials. Additionally, the limitation that only implicit algorithms can be used, exclude post processing algorithms like blur, normal map generation from height or ambient occlusion, because they rely on neighbour informations.

## Ojective
First a understanding for surfaces and their composition must be created. Therefore surfaces have to be analysed, how they can be decomposed in informations, layers, forms and pattern which then can be replicated by algorithms.

To know which algortihms are usefull and in which ways they can be used, a categorisation based on their task is created. This allows the extension and usage of algortihms of own choice.

For reduced Trial-And-Error phases and guide creators to a structural process, a workflow and teqniques will be presented.

Finally the analysis, categorisation, techniques and the capabilities of the workflow are tested by creating procedural textures with them and preseting their results.

Details about implementations of noise or other alogrithms will be not part of this work. As well as a performance analysis of algorithms or entire procedural materials.


# Analysis of surfaces
Through the analysis of a surface we will see that surfaces are often compositions of sub-surfaces. All informations how a surface is layered and how they are madeup is resued later by replicating them, suiting algorithms, order  and teqniques that are available in fragment shaders.

The overall objective of the analysis should not confound with building a physical and chemical understanding of real world materials, which nonetheless may be helpful or necessary. The main objective is to extract patterns and geometric informations about the visual appearance, including height informations. To retrieve these informations, the analysis is carried out in three streps:
- Extracting surface layers
- Visual properties
- Environmental influences

## Level of Detail
TODO: Beschreiben das nicht alles bis in das letzte Detail analysiert werden muss. Kommt darauf an wie detailverliebt das Material werden soll.

## Extracting surface layers
Natural surfaces are build up from multiple real world materials, which work like layers in image editing softwares. Where through blending multiple layers the final image is created. For extracting surfaces into layers; pattern, noise and shape recognition is the key. While many surfaces may have a complex visual appeareance, shapes and patterns still appear on them. A hirachical aproach looking out for patterns and shapes is recomended because the depth of the analysis will differ by the required level of detail. Further a hierarchical separation ensures that created sub-materials can be reused in other materials. Indicators where and how surfaces can be seperated are:
- natural given seperation due to manufaturing or creation *(e.g. bricks and mortar, solar panels)*
- closeness to basic shapes *(pebbles, knobs, nails, tiles)*
- closeness to noise algorithms *(rusting metal, leather)*

For demonstration I took a picture of the floor from a local Pub. The floor is quite old and therefore has a complex apereance. The first seperation is made by the planks, because:
- they break the continuity of the wood structure.
- they control the main height of the surface.
- the space left defines the area for dirt, together they cover the whole surface
- the arrangement and shape suits perfectly for tilling.

![alt][SEP01]
> *Left: Floor of a Pub, Mid: Seperation into planks, Right: Seperation into Gums*

While the first seperation is oriented to the wood structure, the black dots on the floor apear to be independent to the plank strukture. This is because these dots are old trampled chewing gums. So a second seperation is made because the chewing gums:
- are not part of the plank or wood structure, they can overlap planks.
- they are are a physical placed ontop of the floor.

## Visual properties
The surface is now split into several layers of subsurfaces. To fill it with compelling information about color, height, and other properties required for the lighting model, the visual appearance of the surface must be disassembled. Properties which make a surface recognizable are easily seperatable, it nonetheless may be beneficial to know the reason why the properties are how they are. By gathering informations about the origin of properties themself, the properties can be transfered plausible to other related materials.

![alt][WOD01]
> *Left: Plank of a floor in a Pub, Mid: ..., Right: ...*

For the floor from the pub by looking closer to the planks, the typical wood structure can be seen. The structure is made up visually by jiggly lines which are pushed away by darker spots. The physical explanation is that these lines are annual rings, and the darker sports are branches.

TODO: Wie erkläre ich jetzt hier das das Wissen einen weiterbringt? War Holz ein schlechtes beispiel weil obvious? Bzw. das wissen ist ja übertragbar, aber jedes Holz sieht fast so aus.

## Environmental influences
While a surface can be seperated into layers, and the materials which made up the layers are treated seperatly, the surfaces still exists in the environment as single surface. This means the environment where the surface exists has a strong influence to it. The best example are the trampled chewing gums from the pub floor. This property of this specific floor is based on the location. A wodden floor in a living room may not have this proeprty. But there is another property of the pub floor where additional inforation about the location is needed to see and replicate it: The floor is located in a smoking area. Also the floor has all over like "freckles". After a close inspection, these freckles are burned spots from thrown away and trampled cigarett ends.

![alt][SEP02]
> *Left: Plank of a floor in a Pub, Mid: burned spots from trampled cigarett ends, Right: color variation due to spilled liquids*

Environmental influences have are the factors which make materials finnaly beliveable. Thinking of possible chemical and physical interactions and their duration through time will give a procedural materials the final touch. Therefore it is important of gatherin information about location and story of the environment where the material have to be placed.


# Toolbox of algorithms
To use and replicate information from the analysis, an overview of the technical possibilities needs to be created. Therefore available algorithms and mathematical functions will be categorised by their tasks. This is done because interfaces in render applications have diffrent predefined algorithms and functions or they missing. Additionally the categorysation enables adding and changing algorithms to your own needs. The categorization will work like a toolbox with which defined tasks have to be solved. However, the tools contained therein can be selected by yourself.

By creating materials for this thesis, i have collected many algorithms for diffrent purposes. This collection resulted into a small framework of GLSL functions dedicated for creating procedural materials. By collecting algorithms and creating materials, categories for algorithms has been automatically evolved. These categories showed to cover most algorithms and tasks.

## Math
Baisc mathematical methods like "floor", "absolute" or "sinus" are essential general in shaders. For procedural materials every algorithm will be based on these methods. Theire also really usefull when it comes to modifying results from algorithms.

## UV
The UV are texture coordinates for the underlying mesh which is usually used to access textures. Manipulating the UV enables changes like rotation or tilling. For creating procedural materials within fragment shader the UV has a extraordinary meaning. First all generative algorithms like noise or shapes are implicit, the UV represents the arbitrary point for their input.

By influencing the UV, the results of algorithms can be pushed to results which would otherwise result in an inefficent implentation. In general the UV gives access to any modification as simple as well as complex ones, which will take effect regardless of the algorithms that are using it.

![alt][TLUV]
> *Left: uv manipulations; Right: rectangle with same size and position drawn with UV's from left*

## Noise
Surfaces in the real world are often characterized by random patterns,  distributions or other features represented in color, height or other properties. To mimic the randomness in nature noise are the perfect tool.

### Hashing as random nunmber generator
The base of all noise algorithms and random distribution is the access to a random number generator (RNG). While true randomness is hard to achive with computers, it is even undesirable for creating noise. A RNG for procedural materials has to be unpredictable and reproducable at the same time. This is necessary because random values have to be restored, e.g. accessing the value neighbour points in a lattice.

![alt][TLHASH]
> *White noise; Left to right: 1D, 2D, 3D; Bottom to top: Scaled uv with x0.0001, x1.0, x1000*

Hashing is the perfect solution to be used as RNG, because the results are unpredictable but still controllable by the input. The result of a such a noise functions is named "white noise". By looking for hash functions, not any function can be used. The hash algorithms should be consistent over the range of UV scale used in the procedural material. As seen in the figure, the randomness of hash algorithms can break in extreme scales. There is a good listing in the book "Texture & Modeling A procedural approach" of other properties that a hash algorithms have to meet to be used as RNG ("noise" in the quote is refered to be white noise):

"The properties of an ideal noise function are as follows:
- noise is a repeatable pseudorandom function of its inputs.
- noise has a known range, namely, from −1 to 1.
- noise is band-limited, with a maximum frequency of about 1.
- noise doesn’t exhibit obvious periodicities or regular patterns. [...]
- noise is stationary—that is, its statistical character should be translationally invariant.
- noise is isotropic—that is, its statistical character should be rotationally
invariant."[(EMP01)]

### Noise and fractal brownian motion
As mentioned early, surfaces appear to have random but still repetitive patterns. To mimic these features several noise algorithms have been created. The most iconic ones are perlin noise[(P01)] and voronoi nosie[(W01)] as seen in the introduction. The paper "A Survey of Procedural Noise Functions" [(LLC01)] gives a good insight about noises and their types. But not every noise can be implemented in a fragment shader without buffer. Anyway noise can replicate natural features and there are diffrent algorithms for diffrent apereances.

![alt][TLNOISE]
> *Several noises; Left to right: 1D, 2D, 3D; Bottom to top: value, perlin, voronoi; Left: pure noise; Right: with fractal brownian motion*

While noise algorithms result into unpredictable but still regular patterns, the output tends to lack of details. This is the case because noise algorithms will produce random values based on a single frequency. With fractal brownian motion details within the noises can be created, by adding multiple frequencies with diffrent weights. This can be aplied to any noise algorithm.

## Shapes
While surfaces often have natural unpredictable patterns, there are also geometric patterns in nature, like stone weaving, leafs or pebbles. Especially man-made surfaces like walls, floors or windows are made out of gemetric shapes.
To replicate geometric features, algorithms which create basic shapes are needed.

![alt][TLSHAPE]
> *Left: various shapes with blur; Right: Distance fields*

When generating geometric shapes, it is necessary for the algorithms to have a blur parameter, because with the absence of post processing there is not other way to create it. Blur is necessary because shapes and resulting results from shapes will be used as masks or height informations. By bluring the borders of the shapes linear, this border can be manipulates with easing functions for the required transitions.


## Easing
Easing functions may be well know from web programming, or animations. Easing functions provide a elegant and exchangeable way to change the distribution of values within a range.

![alt][TLEASE]
> *Left to right, bottom to top: Exponential, Power, Sinus, Circular*







![alt][COMPLEX]
> *Noise created from noise; Left: noise used as displacement and color; Right: generated noise from multiple perlin noises*



















### Algorithmen
Algorithmen bilden wiederum atomare Bausteine auf die eine prozedurale Textur aufbaut. Ähnlich vergleichbar mit einem Lego Spiel. Die Algorithmen selbst können Parameter definieren um ihr Verhalten zu steuern, sind aber über jedes Material gleich. Um die spezifische Aufgabe und mögliche Verwendung eines Algorithmus besser zu verstehen und eine Austauschbarkeit zu ermöglichen, werden diese nach Ihrer Aufgabe kategorisiert.

#### Noise
Noise Algorithmen bilden wichtige Bausteine um naturgegebene Unregelmäßigkeiten Abzubilden. Noise definiert sich durch [Definition suchen]. Auf diese zufällige nicht vorhersagbare Frequenzen und WhiteNoise kann nun aufgebaut werden. Noise gibt es in vielen Variationen. Durch die unterschiedlichen Charakteristiken von Noise-Algorithmen unterscheiden sich die Einsatzmöglichkeiten.

WhiteNoise nimmt dabei die Rolle eines RNG(Random Number Generator) ein. Sie ist auch die Grundlage aller Noise-Algorithmen. WhiteNoise wird aber auch dann benötigt wenn eine zufällige Entscheidungen getroffen werden sollen.

Wie bereits erwähnt baut Noise auf WhiteNoise auf und Spiegel eine einzelne zufällige Frequenz wieder. Durch Noise können so natürliche Verformungen, Masken und Gradienten erzeugt werden.

Da Noise nur eine einzelne Frequenz widerspiegelt erreicht man nicht immer ein gewünschtes Ergebnis das oft Details wie ausgefranste Ränder fehlen. Dur Fractal Browning Motion können solche Details erzeugt werden. Dabei ist der Grundlegende Noise Algorithmus austauschbar.

#### UV
Als UV bezeichnet man die Texturkoordinaten. Wenn in einem Material Texturen als Informationen für einen Surface-Shader genutzt werden beschreiben diese Koordinaten welche Pixel auf der Textur ausgelesen werden. Diese Koordinaten können als Eingangsinformation verwendet werden um Informationen für einen bestimmten Punkt, durch die Koordinaten gegeben, abzufragen.

Die UV stellt somit die "Leinwand" für ein prozedurales Material dar. Dabei kann die UV in mehrere Teile oder Ebenen aufgeteilt werden. Durch mehrere UV's kann z.B. eine Rotation oder Skalierung von einzelnen Elementen erreicht werden. Durch eine Aufteilung wiederum ist es möglich Elemente sich wiederholen zu lassen. Sowohl bei Aufteilung als auf bei der Manipulation können wieder neue UV's davon abgeleitet werden um noch mehr Details zu erzeugen.

Eine weitere Möglichkeit der Manipulation ist die Konvertierung der Koordinaten in ein anderes System. So kann z.B. kann ein Polar-Koordinatensystem verwendet werden. Dies ermöglich eine weitere Vielzahl an Möglichkeiten Elemente und Merkmale zu erzeugen, für die sonst komplexe Algorithmen hergezogen werden müssten.

Eine weitere wichtige Manipulation von UV's ist das leichte verschieben oder rotieren durch Noise oder andere über die UV variierende Werte. Somit können Verformungen an Formen vorgenommen werden, bzw. eine natürliche Unregelmäßigkeit simuliert werden. Dies kann in das extreme getrieben werden wenn man mehrere Noise Verformungen aneinanderreiht um letztendlich wieder eine Noise auf diesen Koordinaten zu erzeugen [(IQ01)].


#### Shapes
Formen sind für Basis für komplexere Formen. Dadurch das in einem Fragment-Shader nicht auf Nachbarpixel zugegriffen werden kann, empfiehlt es sich für jede Form einen Blur-Parameter zu implementieren. Durch einen weichen Übergang an den Rändern können viele Effekte erreicht werden.


#### Easing
Easing-Algorithmen werden meist beim manipulieren von Höhenkarten und Masken verwendet. Auch kann als Beispiel die Verteilung von WhiteNoise gesteuert werden.


#### Mathematische Funktionen
Nicht alle Algorithmen oder Methoden können unter die anderen Kategorien eingeteilt werden. Manchmal sind diese einfach zu generisch und finden in jedem Bereich seine Anwendung. Nichts desto trotz gibt es Methoden die genauso wichtig sind um Werte zu brachen und manipulieren. 



### Techniken
Techniken definieren sich durch das geschickte kombinieren von Algorithmen um optische Modifikationen oder Eigenschaften zu erreichen. 

Techniken beschreiben das allgemeine Vorgehen und Lösungsansätze für wiederkehrende Aufgaben und Probleme.


#### Höhe als Grundlage
Die Höhe sollte in schwarz weiß dargestellt werden. Schwarz für die Tiefen als 0.0, Weiß für de Höhen als 1.0. Das hat den Vorteil dass das Ergebnis einfach für den AAnwender zu interpretieren ist. Auch ist die Performance von Floating-Point Operationen besser als wenn man mit einem Vektor arbeiten würde.
Viele Algorithmen können somit die Höhenwerte einfach und transparent verarbeiten.

Die Höhe ist deshalb als Grundlage wichtig, da viele visuelle Eigenschaften davon abgeleitet werden können. Es können Aufgrund der Höhe beispielweise Masken erstellt werden um andere Materialien miteinander zu verbinden. Auch die Verteilung von Schmutz und Gebrauchsspuren können mit einer Höhenkarte glaubhaft verteilt werden.

Ein weiterer Vorteil ist die Entstehung eines Non-Destruktiv-Workflows. Sprich da alles was in einem prozeduralen Material geschieht auf der Höhe basiert, kann diese im Nachhinein immer noch bearbeitet werden, ohne die Nachfolgende Arbeit zu zerstören. Die nachfolgende Logik wird auf die neue Höhenverteilung korrekt reagieren. 

Die Bearbeitung der Höhenkarte ist ein Prozess der sich fast bis zum Ende des Materials hindurchzieht.


#### Blending
Durch das Kombinieren von Formen und oder Noise entstehen die gewünschten Merkmale eines Materials. Dies funktioniert wie in einer Bildbearbeitungs-Software. Die miteinander zu verbindenden Ergebnisse sind als Layer zu betrachten. Durch eine gegebene Maske können diese mit einer Blend-Logik miteinander verbunden werden. Dabei muss Blending nicht immer nur zwei eigenständige komplexe Ergebnisse miteinander verbinden. Es kann auch dazu genutzt werden um bestehende Ergebnisse leicht abzuwandeln.

Blending kann im ganzen Material Anwendung finden. Sowohl Höhen können manipuliert werden, als auch Farbwerte.


#### UV-Manipulationen
Viele Ergebnisse der Algorithmen sind für sich stehend oft zu perfekt oder bieten nicht die Nötige Abwechslung und Merkmale. Durch die Manipulation der UV können diese aber so abgewandelt werden um das auszugleichen. Als Beispiel ein zertretener Kaugummi: Nimmt man einen Kreis, manipuliert seine UV mit einer Rotation die durch eine Noise gesteuert wird, können Unregelmäßigkeiten erzeugt werden.


#### Natürliche Unregelmäßigkeit
Durch die Definierung eines Materials mit einer mathematischen Grundlage, entstehen so schnell Ergebnisse die nahe an Oberflächen aus der Realität erinnern, sind aber häufig zu perfekt. Als Beispiel eine geflieste Oberfläche:
Diese sieht bereits glaubhaft aus, kann aber noch weiter verbessert werden. So kann man all Kacheln zufällig um ein paar Grad drehen um den Menschlichen Fehler beim fließen zu simulieren. Zusätzlich können alle Kacheln um ein paar Grad geneigt werden. Eine weitere Noise steuert zuletzt die Kalkablagerung.

Festzuhalten ist, das keine Oberfläche perfekt ist. Eine Oberfläche ist immer äußeren Auswirkungen ausgesetzt. Die können je nach Material und Umgebung sehr unterschiedlich ausfallen. Bei der Analyse sollten diese aber erkannt werden. Ein Material kann somit deutlich an Glaubhaftigkeit und Realismus gewinnen.


#### Seed
Bei der Entwicklung von mehreren prozeduralen Texturen hat sich gezeigt das die Verwendung eines Seed Überschneidungen und Korrelationen innerhalb von Teilergebnissen eines Materials vermieden werden können. Dies liegt daran, das es auf der Grafikkarte kein keinen persistierten Pseudozufallsgenerator gibt. Dieser muss zum einen selbst implementiert werden und mit mindestens einem Eingangswert aufgerufen werden. Um nun innerhalb von Teilergebnissen nicht immer eine magische Nummer statisch im Code verankern zu müssen, ist es Hilfreich bei Methoden die auf Zufall basieren einen Seed-Parameter mit zu implementieren. Dieser kann hierarchisch immer weiter gegeben werden und bei jeder Verwendung oder Weitergabe wird dieser inkrementiert oder verändert.





[PBRNPR]: ./img/pbrnpr.png
[NOISE01]: ./img/noiseExamples.png
[NODEV01]: ./img/nodevember.jpg
>[NODEV01]: https://pbs.twimg.com/media/EL857feW4AAiqYr.jpg
[SEP01]: ./img/planks.png
[SEP02]: ./img/envi.png
[WOD01]: ./img/wood.png
[TLUV]: ./img/uv.png
[TLNOISE]: ./img/noise.png
[TLHASH]: ./img/hash.png
[TLSHAPE]: ./img/shape.png
[TLEASE]: ./img/ease.png
[COMPLEX]: ./img/complex.png



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

[(CIN01)]: https://www.maxon.net/de/produkte/cinema-4d/features/texturing/node-based-materials/
> [(CIN01)]: *Node-Based Materials* | 2020 | Maxon

[(D01)]: https://www.researchgate.net/publication/314637042_The_New_Age_of_Procedural_Texturing
> [(D01)]: *The New Age of Procedural Texturing* | 2015 | Dr S´ebastien Deguy

[(IQ01)]: https://www.iquilezles.org/www/articles/warp/warp.htm
> [(IQ01)]: *domain warping* | 2002 | Inigo Quilez

[(IQ02)]: https://www.iquilezles.org/www/articles/distfunctions2d/distfunctions2d.htm
> [(IQ02)]: *2D distance functions* | ???? | Inigo Quilez

[(IQ03)]: https://iquilezles.org/www/articles/distfunctions/distfunctions.htm
> [(IQ03)]: *distance functions* | ???? | Inigo Quilez

[(K01)]: https://www.khronos.org/opengl/wiki/Fragment_Shader
> [(K01)]: *Fragment Shader* | 2020 | Khronos Group

[(C01)]: https://graphics.pixar.com/library/ShadeTrees/paper.pdf
> [(C01)]: *Shade Trees* | 1984 | Robert L. Cook

[(SD01)]: https://docs.substance3d.com/sddoc/blur-hq-159450455.html
> [(SD01)]: Blur HQ | 2020 | Allegorithmic / Adobe Inc.