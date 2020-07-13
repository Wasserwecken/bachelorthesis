> # GENERATION OF PROCEDURAL MATERIALS WITHIN FRAGMENT-SHADER


# Abstract
...

# Introduction
Procedural texturing always has been a subject in computer graphics. Researchers sought for algorithms and improvements to synthesize textures to represent natural looking surfaces. Early algorithms as Perlin-Noise [(P01)] or Worley-Noise [(W01)] are still present today and essential for procedural texture generation, due to their appearance which suits replicating natural properties.

![alt][Figure01]
> *[Figure01] Images from early papers; Left: Perlin noise [(P01)]; Right: Worley noise [(W01)]*

In the early ages of procedural texture generation, algorithms and renderers where executed on the CPU. But now, "With the ever increasing levels of performance for programmable shading in GPU architectures, hardware accelerated procedural texturing in GLSL is now becoming quite useful[...]" [(G01)]. Implicit algorithms, where a query for information about a arbitrary point is evaluated, suiting perfectly the conditions for fragment shaders, because it's task is to return the color of a arbitrary pixel without knowledge about it's neighbors [(K01)]. Some Algorithms like Perlin-Noise already defined implicit. Other Algorithms may need some modifications to be used implicit, e.g. rendering shapes, where distance fields can be used to represent them implicit [(IQ02)], [(IQ03)]. But as concluded in the quoted paper from Gustavson: "[...] modern shader-capable GPUs are mature enough to render procedural patterns at fully interactive speeds [...]" [(G01)].

Today, a variety of modern 3D applications like  "Blender" [(BLE01)], "Unity 3D" [(UNI01)], "Unreal Engine" [(UNR01)] or "Cinema 4D" [(CIN01)] offering a interface to the attached renderer to handle the shading of objects in a modular manner, as proposed in the paper "shade trees" [(C01)]. While these interfaces enabling modifications to shading, it also enables generating procedural information, because they work and behave like a fragment shader.
These interfaces already take advantage of this architecture and shipping with a variety of predefined algorithms to hide the complexity of those, like noise generation or UV projection. The possibilities of these interfaces can pushed so far that convincing and abstract Surfaces can be created with them, without dependencies to textures or other external references.

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

The order of the named objectives will also represent the following structure of this thesis. Details about implementation or specific algorithms will be not part of this work. As well as a performance analysis of algorithms or entire procedural materials.


# Analysis of surfaces
The overall objective of the analysis should not confound with building a physical and chemical understanding of real world materials, which nonetheless may be helpful or necessary. The main objective is to extract patterns and geometric information about the visual appearance. To retrieve these information, the analysis is carried out in three steps:
- Extracting surface layers
- Visual properties of materials
- Environmental influences

The extraction process is relying completely on pattern, noise and shape recognition. And the retrieved information about the surface composition and visual features is reused later by replicating them with suiting algorithms, order and techniques that are available in fragment shaders.

## Extracting surface layers
By looking to natural surfaces they can been seen as a composite of multiple sub surfaces. By separating the surfaces into different layers of sub-surfaces, these layers are later reassembled in the same manner as image editing software does this through blending them into an final image. Indeed there will be no final image, as every point in the final rendered surface is arbitrary, the blending will result into a final point of information. A hierarchical approach looking out for layers is recommended, because first the depth of the analysis will differ by the required level of detail. Secondly, breaking a surface into a hierarchy of multiple layers makes them more clear and patterns are more recognizable. Further the hierarchical approach also ensures that replicated sub-materials can be reused in other materials.

Unfortunately there are no specific factors which will define the layers which a material is made of. But there are indicators that can help:
- natural given separation due to manufacturing or creation *(e.g. bricks and mortar, solar panels)*
- similarities to shapes *(pebbles, knobs, nails, tiles)*
- similarities to noise *(rusting metal, leather)*

In general most natural surfaces themselves are already composed of different materials. This can have physical causes like leaves on the ground or screws in furniture, other times there are chemical reasons like oxidation. These causes are also good indicators where a surface can be separated into sub-surfaces. 

For demonstration of the separation I took a picture of the floor from a local Pub. The floor is quite old and therefore has a complex appearance.

![alt][Figure04]
> *[Figure04] Left: Floor of a Pub; Mid: Separation by planks; Right: Separation by trampled gums*

The first separation is made by the planks, because:
- they break the continuity of the wood structure.
- they control the main height of the surface.
- the space left defines the area for dirt.
- the arrangement and shape suits perfectly for tilling.

While the first separation is oriented to the wood structure, the black dots on the floor appear to be independent to the plank structure. This is because these dots are old trampled chewing gums. So a second separation is made because the chewing gums:
- are not part of the plank or wood structure, they can overlap planks.
- are made out of a different material than wood.
- they are a physical placed on top of the floor.

## Visual properties of materials
After separating a surface in multiple layers, visual properties about the isolated materials have to be extracted for recreation. Again a hierarchical approach is recommended, this time driven by the strikingness / obtrusiveness of visual features. By looking to the most strikingness / obtrusiveness features first, the material will be later immediate recognizable. And the hierarchical approach will match the workflow for reassembling materials by iterating from rough to small details and features in the surface structure which are unnecessary for the required level of detail will be ignored.

To extract features of a surface, recognizing patterns, shapes and noise are again important. Because later by reassembling the material, the materials themselves will be created by layers of and dependencies between the different extracted features. It is the same process as extracting layers, showed by [Figure04]. To continue the demonstration a single plank will be analyzed for recreating the wood material.

![alt][Figure05]
> *[Figure05] Left: Single plank of the floor; Mid: annual rings, Right: branches*

The floor of the pub is made of wooden planks. The two most recognizable features of wood are annual rings and branches, which are definitely present in the reference photo. There would be many more features which can be extracted from the reference photo, but the two initial features, annual rings and branches, are enough for a first approach / iteration of recreation. Also the depth of the analysis can be adjusted while reassembling the material. These processes can run in parallel. If the material will later lack of detail to match the required level, the analysis will be continued where it stopped before. This is another advantage of analyzing surfaces in a hierarchical manner.

## Environmental influences
While a surface can be separated into layers, and the materials which made up the layers are treated separately, the surfaces still is present as single surface in the environment. This means the environment where the surface exists has a strong influence to it, the trampled chewing gums on the floor as example are a result of an environmental influence. This is because the floor is located in a public place, a wooden floor in a living room may not have the feature of trampled gums.

Visual features which may appear at first glance inexplicable often can be explained by looking though the history of an surface. Environmental influences are the factors which make materials finally believable. Thinking of possible chemical and physical interactions and their duration through time will give a procedural materials the final touch. This cannot only applied to reference photos, this knowledge can also applied factionary to any surface to mimic a surface in a specific environment.

As mentioned early, the floor in the pub is no exclusion to that and environmental influences took place in the visual appearance.

![alt][Figure06]
> *[Figure06] Left: Floor in a Pub; Mid: burned spots from trampled cigarettes; Right: color variation due to spilled liquids*

Another information about the environment is that the floor is located in a smoking area. And in the reference photo there are all over small dark points like "freckles" on the floor. After a close inspection, these freckles are burned spots from thrown away and trampled cigarettes. Another information which is obvious in a pub is the possibility of spilled liquids. These liquids cannot be wiped away immediately, so the liquid will be soaked up from the floor. This leads to discolorations.


# Toolbox of algorithms
By creating materials for this thesis, several algorithms have been collected for different purposes. The collection resulted into a small library of GLSL functions dedicated to create procedural materials. While collecting algorithms, categories evolved over time which represented the purpose of the algorithms. These categories showed to cover all the tasks of procedural texturing. Categorizing algorithms about their task has also other advantages. A categorization allows to use algorithms of own choice and implementation. This is important because each render application interface will provide a different subset of algorithms in availability and implementation. With the categorization the subset can be extended to match later the workflow of creating procedural materials. Overall the categorization will work like a toolbox with which defined tasks have to be solved. However, the tools contained therein can be selected by yourself.

## Basic math
Basic mathematical methods like "floor", "absolute" or "sinus" are essential general in shaders. Every algorithms will rely on their ability to either break or create gradients. But their not only useful when it comes to create powerful complex algorithms, using basic mathematic functions to process results from previous calculations and algorithms will be a common task too. Many results later will be represented through a one dimensional value between 0 and 1, therefore these algorithms can be easily applied.

## UV
The UV, better known as texture coordinates, are as essential for procedural materials as basic math functions. The UV's basically defines the space where and how any information is is drawn. Due to this meaning of UV's, manipulating them has a huge influence to the results of algorithms. First basic transformations as translate, rotate and scaling are achieved by manipulations to the UV. Otherwise these transformations have to be implemented in every single generative algorithm, which is not recommended and creates unnecessary redundancy. Another advantage about manipulating the UV with dedicated algorithms is the option to reuse the manipulated UV for subsequent algorithms.

![alt][Figure07]
> *[Figure07] Left: UV manipulations; Right: rectangle with same size and position drawn with UV's from left*

Besides transforming the UV, there are other important manipulations which should be named. Often surfaces have repetitive shapes or patterns. These can be replicated by tilling the UV. Tilling is showed in [Figure07], middle row first column. With tilling the UV will be splitted into independent repetitive UV's. Another useful kind of manipulation is to change the mapping of the coordinates itself. By default the UV represents a cartesian coordinate system. By converting the system into another one, like the polar coordinate system, some desired shapes or patterns may can be achieved more easily. The affect of the polar coordinate system to a basic shape is also shown in [Figure7], bottom row, second column.

## Noise
Noise algorithms are the element which enables reassembling unpredictable patterns or random distributions on surfaces. There are two kinds of algorithms for this category. The first are algorithms that will work as pseudo random number generators (RNG), the second are the noise algorithms themselves which rely on the RNG's to create unpredictable still repetitive gradients.

### Hashing as random number generator
The base of all noise algorithms and random distributions is the access to a random number generator (RNG). While true randomness is hard to achieve with computers, it is even undesirable for creating procedural noise. A RNG for procedural materials has to be unpredictable and reproducible at the same time. Often algorithms need to restore random values e.g. accessing the value of neighbor points in a lattice.

![alt][Figure08]
> *[Figure08] White noise; Left to right: 1D, 2D, 3D; Bottom to top: Scaled by x0.0001, x1.0, x1000.0*

Hashing is the perfect solution to be used as RNG, because the results are unpredictable but still controllable by the input. The result of a such a noise functions is named "white noise". By looking for hash functions, not any function can be used. The hash algorithms should be consistent over the range of UV scale used in the procedural material. As seen in the figure, the randomness of hash algorithms can break in extreme scales. There is a good listing in the book "Texture & Modeling A procedural approach" of other properties that a hash algorithms have to meet to be used as RNG ("noise" in the quote is referred to be white noise):

"The properties of an ideal noise function are as follows:
- noise is a repeatable pseudorandom function of its inputs.
- noise has a known range, namely, from −1 to 1.
- noise is band-limited, with a maximum frequency of about 1.
- noise doesn’t exhibit obvious periodicities or regular patterns. [...]
- noise is stationary—that is, its statistical character should be translationally invariant.
- noise is isotropic—that is, its statistical character should be rotationally
invariant."[(EMP01)]

### Noise base functions
Base functions of noise are considered as functions which create repetitive unpredictable gradients by interpolating random numbers. The paper "A Survey of Procedural Noise Functions" [(LLC01)] gives a good insight about the noises themselves and a categorization of their types. The may most known algorithms are perlin noise[(P01)] and voronoi noise (also known as cellular noise)[(W01)].

![alt][Figure09]
> *[Figure09] Several noises; Left to right: 1D, 2D, 3D; Bottom to top: value, perlin, voronoi; Left: pure noise; Right: fractal brownian motion based on left sided algorithms*

As shown in [Figure09] the visual appearance of noise can be very different. This is useful in terms of mimicking different natural patterns, where some algorithms are better suited than other. Another consideration of collecting algorithms besides the visual appearance is their application in different dimensions than 2D. One dimensional noises are quite useful when it comes to created color gradients. Their result could either be used to mix defined colors, or their results could control a single color channel. A good example of controlling color channels was made by Inigo Quilez where he used a single  offsetted and scaled cosines function for each channel [IQ04].

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
While the base noise functions are useful to create unpredictable patterns, often their appearance is not detailed enough for many purposes. The lack of details is due the limited frequency in the noise. Lattice based noises will have a single frequency projected in their result. Layering the base functions can bring details into noises or create other visual appealing features.

### Fractal Brownian motion
Fractal Brownian motion (fBm) is a well known approach to combine multiple frequencies to create noise rich in details. It describes an additive layering of the same noise algorithm with different weights, scale and iterations. This can be done basically with any noise as shown in [Figure09] on the left side.

### Noise by Noise
The base noise algorithms, even extended by fBm, may do not cover all cases of  unpredictable patterns. To extend the toolbox of noises even more, noise can be combined in any way to create new complex noises for reassembling grunge or other surface features.

![alt][Figure10]
> *[Figure10] Complex noise; Left: complex noise used for displacement and color; Right: generated complex noise by base noise functions*

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

[Figure10] shows a complex noise which was generated combining the results of base noise functions. This noise also used a single algorithm as base, however there are no restrictions in any way for creating complex noise. Many render applications make use of this technique to provide their users a great selection of patterns. These complex noises can amongst other things mimic surface features like scratches, cracks and grunge.


## Imperfections
By looking to surfaces from the real world, one thing they have all in common: They have all flaws in any way. This is what makes convincing and beliveable surfaces. Ment with flaws are impefections on the surfaces of any size. Examples of imperfections in surfaces are scratches, dents, discolorations, dust, fingerprints or human failure.

























[Figure01]: ./img/earlyNoise.png
[Figure02]: ./img/nodevember.jpg
[Figure03]: ./img/pbrnpr.png
[Figure04]: ./img/planks.png
[Figure05]: ./img/wood.png
[Figure06]: ./img/envi.png
[Figure07]: ./img/uv.png
[Figure08]: ./img/hash.png
[Figure09]: ./img/noise.png
[Figure10]: ./img/complex.png

>[NODEV01]: https://pbs.twimg.com/media/EL857feW4AAiqYr.jpg
[TLSHAPE]: ./img/shape.png
[TLEASE]: ./img/ease.png
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

[(IQ04)]: https://iquilezles.org/www/articles/palettes/palettes.htm
> [(IQ04)]: *palettes* | 1999 | Inigo Quilez

[(K01)]: https://www.khronos.org/opengl/wiki/Fragment_Shader
> [(K01)]: *Fragment Shader* | 2020 | Khronos Group

[(C01)]: https://graphics.pixar.com/library/ShadeTrees/paper.pdf
> [(C01)]: *Shade Trees* | 1984 | Robert L. Cook

[(SD01)]: https://docs.substance3d.com/sddoc/blur-hq-159450455.html
> [(SD01)]: Blur HQ | 2020 | Allegorithmic / Adobe Inc.