> # GENERATION OF PROCEDURAL MATERIALS WITHIN FRAGMENT-SHADER


# Abstract
...

# Introduction
Procedural texturing always has been a subject in computer graphics. Researchers sought for algorithms and improvements to synthesize textures to represent natural looking surfaces. Early algorithms as Perlin-Noise [(P01)] or Worley-Noise [(W01)] are still present today and essential for procedural texture generation, due to their appearance which suits replicating natural properties.

![alt][Figure01]
> *[Figure01] Images from early papers; Left: Perlin noise [(P01)]; Right: Worley noise [(W01)]*

In the early ages of procedural texture generation, algorithms and renderers where executed on the CPU. But now, "With the ever increasing levels of performance for programmable shading in GPU architectures, hardwareaccelerated procedural texturing in GLSL is now becoming quite useful[...]" [(G01)]. Implicit algorithms, where a query for information about a arbitrary point is evaluated, suiting perfectly the conditions for fragment shaders, because it's task is to return the color of a arbitrary pixel without knowledge about it's neighbors [(K01)]. Some Algorithms like Perlin-Noise already defined implicit. Other Algorithms may need some modifications to be used implicit, e.g. rendering shapes, where distance fields can be used to represent them implicit [(IQ02)], [(IQ03)]. But as concluded in the quoted paper from Gustavson: "[...] modern shader-capable GPUs are mature enough to render procedural patterns at fully interactive speeds [...]" [(G01)].

Today, a variety of modern 3D applications like  "Blender" [(BLE01)], "Unity 3D" [(UNI01)], "Unreal Engine" [(UNR01)] or "Cinema 4D" [(CIN01)] offering a interface to the attached renderer to handle the shading of objects in a modular manner, as proposed in the paper "shade trees" [(C01)]. While these interfaces enabling modifications to shading, it also enables generating procedural information, because they work and behave like a fragment shader.
These interfaces already take advantage of this architecture and shipping with a variety of predefined algorithms to hide the complexity of those, like noise generation or UV projection. The possibilities of these interfaces can been pushed so far that convincing and abstract Surfaces can be created with them, without dependencies to textures or other external references.

![alt][Figure02]
> *[Figure02] Procedural Materials in Blender, created for "Nodevember"; Made by Simon Thommes 2019*

## Annotations
By dealing with render applications, procedural texture generation and shaders, some terms can have similar meaning and sound. Therefore important terms and their meaning in this work have to be defined to prevent misunderstandings.

### Procedural
The paper "A Survey of Procedural Noise Functions" gave following definition:
"The adjective procedural is used in computer science to distinguish entities that are described by program code rather than by data structures. Procedural techniques are code segments or algorithms that specify some characteristic of a
computer-generated model or effect." [(LLC01)]

### Texture
Textures are images where a single or more information about surface properties can be stored. Combined with the definition for "procedural", procedural textures are defined as: "A procedural texture is a computer-generated image created using an algorithm [...], instead of a digital painting or image processing application[...]" [(D01)]. These textures are then later used to drive the properties of the surface shader.

### Material
Most render applications will use the term "material" for the combination of the used lighting model and the collection of information about the surface which should be drawn. In this work the term "material" will be used for the collection of information only, excluding the lighting model because the lightning model has only a minor influence to the process of replicating a surface in a procedurally manner.

![alt][Figure03]
> *[Figure03] Different lighting models, same material information; Right: Physical based (PBR); Left: Non-photorealistic (NPR)*

As seen in the figure, with different lighting models the visual appearance of surfaces can change drastically, even if the offered properties are the same. The lightning model will influence the result of procedural materials which are gonna specially made for it, because specialized properties may have to be controlled by the material. Nonetheless this will not change the general approach of how to analyze and replicate surfaces. Used techniques and algorithms will stay the same, regardless which lightning model will process the information.


## Motivation
While its possible to use and layer multiple algorithms in shader and in interfaces of various render applications, creating procedural materials can be a tedious and complex task. Manipulating results of algorithms in the right manner relies on repetitive tasks and practical knowledge to get convincing results. While there many possibilities and creative freedom for manipulations and choice of algorithms, shader and interfaces in render applications will not enforce or guide creators to a workflow of creating procedural materials. In addition the limitation implicit algorithms can be used only, excludes post processing algorithms like blur, normal map generation from height or ambient occlusion, because they rely on neighbor information. These neighbor information can not be accessed within a shader without additional buffers. Buffers are not available in every render application and if, the usage of them will vary per application.

## Objective
First a understanding for real world surfaces and their composition must be created. Therefore they have to be analyzed, how they can be decomposed in distinct information, layers, forms and patterns. Which then can be replicated by algorithms.

To know which algorithms are suited for procedural generation and which common use cases exist for them, a categorization based on their task is created. This allows the usage of algorithms of own choice and implementation.

To reduce Trial-And-Error phases and guide creators to a structural process, a workflow and techniques will be presented.

Finally the analysis, categorization, techniques and the capabilities of the workflow are tested by creating a procedural texture and documenting each step.

Details about implementation or specific algorithms will be not part of this work. As well as a performance analysis of algorithms or entire procedural materials.


# Analysis of surfaces
The overall objective of the analysis should not confound with building a physical and chemical understanding of real world materials, which nonetheless may be helpful or necessary. The main objective is to extract patterns and geometric information about the visual appearance. To retrieve these information, the analysis is carried out in three steps:
- Extracting surface layers
- Visual properties
- Environmental influences

All information about the surface composition and visual features is reused later by replicating them with suiting algorithms, order and techniques that are available in fragment shaders.

## Level of Detail
TODO: Beschreiben das nicht alles bis in das letzte Detail analysiert werden muss. Kommt darauf an wie detailverliebt das Material werden soll.

## Extracting surface layers

By looking to natural surfaces they can bee seen as a composite of multiple sub-surfaces, separated physically. 

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
While surfaces often have natural unpredictable patterns, there are also geometric patterns in nature, like stone weaving, leafs or pebbles. Especially man-made surfaces like walls, floors or windows showing gemetric shapes.
To replicate geometric features, algorithms for shapes are necessary. Most of geometric patterns in surfaces can be replicated with basic shapes like circles or rectangles, even if there have a complex apereance. Shapes are gonna be used as template which then later are manipulated or composed to complex shapes.

![alt][TLSHAPE]
> *Left: various shapes with blur; Right: Distance fields*

As mentioned before, the usage of shapes later is replicating geometric patterns. These patterns can result in informations like height or color. And often these patterns have transitions. To support these transitions the algorithms which create the shapes are required to have a blur parameter. Unfortunately this has to be done within the shape generation, because after the generation there is no way to blur a shape or information without access to its neighbours, and in shaders this access is missing. To enable bluring shapes, distance functions fulfilling this requirement the most. With a distance field, the area of the shape and its blur can be set by steping the distance. Inigo Quilez made a nice listening of several distance functions in 2D and 3D space on his website [(IQ02)].

## Easing
Easing functions may be well known from web programming or animations. Easing functions provide a elegant way to change the distribution of linear interpolation. Easing functions in procedural materials are used to modify height interformations or change the transitions in blending.

![alt][TLEASE]
> *Left to right, bottom to top: Exponential, Power, Sinus, Circular*


# Workflow
By creating procedural materials, algorithms are often used in a repetitive or specific manner to achive certain results. Teqniques and aproaches which help creating procedural materials will be part of this section.

## Height first
The most visually perceptible characteristic of surfaces is height. Height influences distortions in reflections, the amount of recived light, ambient occlusion, selfshadowing and more. Therefore it is a good practice to start off with height first to get all details right which will end in a more belivable material.

Height should be represented as single value between zero and one. This will allow efficent processing and many algorithms like easing are already expecting this range. 

DERIVING!

## Distortions
Shape and noise algorithms are a start for reasemble surface structures, but these algortihms may are to perfect or to uniform to replicate wanted surface structures. Structures in natural surfaces have often imperfections because pof various reasons as human failure or aging. While it is possible to implement deformation logic into the shape and noise algortihms themself, this is not recommended, this will limit the generating algorithm so specific usecases. To break the perfect uniform nature of noise and shape algorithms, their paramters can be manipulated with shapes or noises.

![alt][IQFBM]
> *manipulated UV with noise for noise: "f(p) = fbm(p + fbm(p + fbm(p)))" [(IQ03)]*

Manipulating the UV with noise or other patterns can emulate unregularities of natural or manufatured surfaces. While manipulating the UV is one way, all other parameters can be manipulated in the same manner to, which will lead to unique results.

## Seed
As mentioned earlier, the random number generator for procedural materials is based on hashing. Hasing needs an input to create pseudo random numbers. Noise uses this hashing for creating random values, incrementing the input for each new random value which is required. While this is fine and works perfectly, procedural materials will not make use of a single noise only, they will use a couple of them. Noise of diffrent kinds, scale, rotation or offset. The risk is, by using the same noise over and over can lead to coincidences by layering noises of the same kind. Another requirement within procedural materials is to break the continoius structure of noises to reassamble surfaces which are made of physically seperate but same kind of materials. To ensure the reuability of the algorithms and created sub-materials, every functions which uses hasing in any way should have a seed parameter. This parameter ensures the diversity of noises, materials and randomness. The parameter should also be inhertied by functions which make use of functions that require seed.

## Make more noise
While noise is a essential part for procedural materials, noise is not only restricted to be generated by interpolating random values on a lattices. TO have a extended variety of noise, new and more complex noises can be created from basic noise algorithms.

![alt][COMPLEX]
> *Complex noise; Left: complex noise used for displacement and color; Right: generated complex noise from basic noises*

```glsl
float noise_complex(vec2 point, vec2 seed)
{
    float complex = 1.0;
    for(int i = 0; i < 3; i++)
    {
        float noise = noise_perlin(point, seed++);
        noise = noise_vallies(noise); // --> abs(noise * 2.0 -1.0)
        complex = min(complex, noise);
    }

    return easing_power_out(complex, 3.0);
}
```
> Code for the complex noise shown in figure

There are no rules or limits when it comes to create new complex noises. In the figure above the complex noise pattern was created by using perlin noise, extracted the creases and took the minimum of three layers of them. Complex noises can reasamble patterns which existing on many surfaces like grunge  platter or crackels.

## Imperfections
By looking to surfaces from the real world, one thing they have all in common: They have all flaws in any way. This is what makes convincing and beliveable surfaces. Ment with flaws are impefections on the surfaces of any size. Examples of imperfections in surfaces are scratches, dents, discolorations, dust, fingerprints or human failure.

























[Figure01]: ./img/earlyNoise.png
[Figure02]: ./img/nodevember.jpg
[Figure03]: ./img/pbrnpr.png

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
[IQFBM]: ./img/iqfbm.jpg



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

[(IQ02)]: https://www.iquilezles.org/www/articles/warp/warp.htm
> [(IQ02)]: *Warp* | 2002 | Inigo Quilez

[(IQ02)]: https://www.iquilezles.org/www/articles/distfunctions2d/distfunctions2d.htm
> [(IQ03)]: *2D distance functions* | ???? | Inigo Quilez

[(IQ03)]: https://iquilezles.org/www/articles/distfunctions/distfunctions.htm
> [(IQ03)]: *distance functions* | ???? | Inigo Quilez

[(K01)]: https://www.khronos.org/opengl/wiki/Fragment_Shader
> [(K01)]: *Fragment Shader* | 2020 | Khronos Group

[(C01)]: https://graphics.pixar.com/library/ShadeTrees/paper.pdf
> [(C01)]: *Shade Trees* | 1984 | Robert L. Cook

[(SD01)]: https://docs.substance3d.com/sddoc/blur-hq-159450455.html
> [(SD01)]: Blur HQ | 2020 | Allegorithmic / Adobe Inc.