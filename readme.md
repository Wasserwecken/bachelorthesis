> # GENERATION OF PROCEDURAL MATERIALS WITHIN FRAGMENT-SHADER


# Abstract
TODO: Muss noch geschrieben werden



# Introduction
Procedural texturing always has been a subject in computer graphics. Researchers sought for algorithms and improvements to synthesize textures to represent natural looking surfaces. Early algorithms like Perlin-Noise [(P01)] or Worley-Noise [(W01)] are still present today and essential for procedural generations, due to their natural looking appearance which suits replicating natural surface properties.

![alt][Figure01]
> *[Figure01] Images from early papers; Left: Perlin noise [(P01)]; Right: Worley noise [(W01)]*

Today, "With the ever increasing levels of performance for programmable shading in GPU architectures, hardware accelerated procedural texturing in GLSL is now becoming quite useful[...]" [(G01)], because "[...] modern shader-capable GPUs are mature enough to render procedural patterns at fully interactive speeds [...]" [(G01)]. Which enables essential algorithms types for procedural pattern generation like noise or distance fields to be used as implicit implementation in shaders, because shaders will query for information about arbitrary points, set by the current pixel distribution.

Today, a variety of modern 3D applications like  "Blender" [(BLE01)], "Unity 3D" [(UNI01)], "Unreal Engine" [(UNR01)] or "Cinema 4D" [(CIN01)] offering interfaces to attached renderers to handle the shading of objects in a modular manner, as proposed in the paper "shade trees" [(C01)]. Besides enabling modifications to the shading of the mesh and creative abstract lightning models like toon shading, it enables at the same time generating procedural surface property information. While the interfaces of real time renderer already make use of the GPU with fragment shaders, offline render applications ,which are ray tracing the scene instead of rasterizing, require also implicit algorithms to evaluate a surface color at arbitrary points by ray intersections. Therefore the functionality and behavior of these interfaces are oriented towards fragment shaders. The interfaces are also shipped with abstract implementations of various useful algorithms to hide the underlying complexity.

Artists like Simon Thommes already pushed the limits of these interfaces really far and they were able to create stunning materials, only using procedural methods without any dependency to external resources like textures.

![alt][Figure02]
> *[Figure02] Procedural Materials in Blender, created for "Nodevember"; Made by Simon Thommes 2019*


## Motivation
Due to the possibility to use and layer multiple algorithms in shaders and interfaces of various render applications, creating procedural materials can be still a tedious and complex task. Manipulating results of algorithms in the right manner often relies on repetitive tasks and practical knowledge to get convincing results. Because the endless possibilities and creative freedom for manipulations and choice of algorithms in shaders and interfaces of render applications will not enforce or guide creators to a specific workflow to create procedural materials. And additionally, only implicit algorithms for pattern generation can be used, because of the shader architecture. This excludes the use of post processing algorithms like blur, normal map generation from height or ambient occlusion. Post processing algorithms rely on neighbor information which cannot be accessed without buffers in fragment shaders. Buffers are not available in every render application interface and if it does, the usage of them can vary for each render application interface.

## Objectives
This thesis will serve multiple objectives. First, an understanding for real world surfaces and their composition should be created. Therefore they have to be analyzed how they can be decomposed in distinct information, layers, forms and patterns. Secondly, to know which algorithms are suited for procedural generation and which common use cases are occurring, a categorization based on their task and type needs to be created. Thirdly, guidelines have to be defined, in order to reduce Trial-And-Error phases and guiding creators to a structural process. Finally the analysis, categorization and the capabilities of the workflow are tested by creating a procedural texture and documenting each step.

The order of the named objectives will also represent the structure of the thesis. Details about implementation or specific algorithms are not part of this work. As well as a performance analysis of algorithms or entire procedural materials.


# Prerequisites
By dealing with render applications, procedural texture generation and shaders, some terms can have similar meaning and sound. Therefore their meaning in this work has to be defined to prevent misunderstandings.

## Procedural
The paper "A Survey of Procedural Noise Functions" defined “procedural” as:
"The adjective procedural is used in computer science to distinguish entities that are described by program code rather than by data structures. Procedural techniques are code segments or algorithms that specify some characteristic of a
computer-generated model or effect." [(LLC01)]

## Texture
Textures are images where a single or more information about surface properties is stored. Combined with the definition for "procedural", a “procedural texture” is defined by Dr Sebastien Deguy as: "[...] a computer-generated image created using an algorithm [...], instead of a digital painting or image processing application[...]" [(D01)]. Render applications are then using these textures to feed the properties of an assigned lightning model.

## Material
Most render applications using the term "material" for the combination of the used lighting model and the collection of information for the lightning model, like albedo or specularity. This thesis uses the term "material" for the collection of information only, excluding the lighting model. Because the lightning model has only a minor influence on the process of replicating a surface in a procedural manner.

![alt][Figure03]
> *[Figure03] Different lighting models, same material information; Right: Physical based (PBR); Left: Non-photorealistic (NPR)*

As seen in the figure, with different lighting models the visual appearance of surfaces can change drastically, even if the offered information about the surface properties are the same. The lightning model can influence the process of procedural materials by requiring special information. Nonetheless this will not change the general approach of how to analyze and replicate surfaces, as well as the underlying techniques and algorithms.

## Implicit and explicit algorithms
Implicit algorithms are more suited for procedural materials than explicit ones. The difference between those two is that an implicit algorithm will answer a query about an arbitrary point and returns information exclusively for it. While an explicit algorithm returns the whole result, evaluated for a resolution defined by the renderer and not by the shader itself. [(EMP01)] Due to the architecture of shaders, regardless of weather used by ray tracing or rasterization, the task of shaders is to evaluate arbitrary points of a surface. These points are defined either in rasterization by the current resolution and view, in case of ray tracing are the points determined by the hit location of emitted rays. Implicit algorithms which can return results to these points without dependencies to neighbor point information and resolution are therefore preferred or even necessary.

## Pro & contra of procedural patterns within fragment shaders
Related work already has explored and analyzed several advantages and disadvantages of pattern creation in fragment shaders, besides the named problems for the motivation.. While they are not part of this thesis they still have to be pointed out. The book “Texturing and Modeling - A Procedural Approach” [(EMP01)] already made a good listening of these pros & cons which can be represented shortened as:
- The size of a procedural representation is way smaller than saving their result as texture.
- The evaluation can be executed at any resolution.
- Procedural materials can be parameterized to change the appearance and features.

Disadvantages are:
- The development process can be difficult, because of the complexity of algorithms and the lack of debug possibilities.
- Results of chaining algorithms are hard to plan without practical knowledge.
- Evaluating can be slower than accessing textures.
- Aliasing can be a problem, especially for far zoomed out textures.




















# Analysis of surfaces
The overall objective of the analysis should not confound with building a physical and chemical understanding of real world materials, which nonetheless may be helpful or necessary. The main objective is to extract patterns and geometric information about the visual appearance. To retrieve these information, the analysis of surfaces is carried out in three steps:
- Extracting surface layers
- Visual properties of materials
- Environmental influences

The steps were derived on one hand by looking through guides of the specialized software for procedural texture creation “Substance Designer” [(SD03)], and on the other hand by transferring the knowledge to a pure shader based environment. While creating several textures, these steps have been evolved over the time by analyzing several types of surfaces with the goal in mind to get the information as structured as possible. To support each step in their explanation, their concept is applied to an example reference photo of a wooden floor in a Pub.

The proposed extraction steps rely on pattern, noise and shape recognition. The retrieved information about the surface composition and visual features is reused later by replicating them with matching algorithms, order and techniques that are available to fragment shaders. To utilize the extracted information, they can either be implemented directly while analyzing the surface in parallel or persisted in any preferred way. The implementation does rely on the content of the information, not on its persistence.


## Extracting surface layers
Separating surfaces into different layers of sub-materials helps later to reassemble the surface in the material in the same manner as image editing software does this through blending them into an final image. In addition the separation serves as simplification to the reference surface to overcome possible complex compositions, which then can be understood more easily detached from other influences.

A hierarchical approach for looking out for layers is recommended, because the depth of the analysis will differ by the required level of detail for the material. Further the hierarchical approach can also mimic the creation process, physical and chemical processes over the lifetime. These influences create natural layers of materials on a surface, like leaves on the ground, oxidations or screws in furniture, which almost matches the chronological appearance and history of the surface. Another advantage of a hierarchical approach is the option that replicated materials can be reused in other materials, because the layering should only control their distribution in the final material.

Factors which are decisive for separations are:
- Physical factors; Many surfaces are already separated naturally through manufacturing processes, like stone walls and floors, where the final surface is man made. It also includes occurrences where different materials are placed on top or worn away without initial intent, like posters on a wall, leaves on grass or peeled plaster
- Chemical Factors; surfaces will change their appearance over time. Oxidation is a typical everywhere occurring process for metals, where the metal slowly converts to rust.
- Abstract patterns; Surfaces may also have noticeable features which are expressed in height, color or other properties without dependency to a distinctive material. Patterns on wallpapers or height structures on surfaces to provide more grip are an example of that.


![alt][Figure04]
> *[Figure04] Left: Floor of a Pub; Mid: Separation by planks; Right: Separation by trampled gums*

The first separation is made by the wooden planks, because:
The planks are physically separated and are independent to each other.
they are the most perceptible feature of the floor.
they control the base height of the surface.
the arrangement and shape results in an almost regular pattern.

While the first separation is oriented to the wood structure, the black dots on the floor appear to be independent to the plank structure. This is because these dots are old trampled chewing gums. Therefore a second separation is made since:
- they do not show a dependency to the plank or wood structure and overlap some planks.
- they are a different material than wood.
- they are physically placed on top of the floor.


## Visual properties of materials
After separating a surface in multiple layers, visual properties about the isolated materials have to be extracted for recreation. Again a hierarchical approach is recommended, this time driven by the obtrusiveness of visual features, which ensures that the material is later immediately recognizable. The hierarchical approach matches the later proposed workflow for implementation by iterating from rough to small details. This takes only features into account which are necessary and required by level of detail for the material.

While the factors for the separation often are quite obvious, the extraction of features from materials is still oriented to the named factors earlier.


![alt][Figure05]
> *[Figure05] Left: Single plank of the floor; Mid: annual rings, Right: branches*

The floor planks are made of wood. The two most recognizable features of wood are annual rings and branches, which are also represented in the reference photo. There are more features in the reference photo which can be extracted, but the two initial features, annual rings and branches, are enough for a first recognizable implementation of a wood material.

## Environmental influences
While a surface can be separated into layers, and the materials which made up the layers are treated separately, a surface is still part as a single instance of the environment. This means the environment where the surface exists has a strong influence on the appearance. Trampled chewing gums on the floor are a result of an environmental influence, because the floor is located in a public place, a wooden floor in a living room may not have the feature of trampled gums.

Visual features which may appear at first glance inexplicable often can be explained by looking though the history of a surface. Environmental influences are the factors which make materials finally believable. Thinking about the environment and gathering background information about the history, conditions or story can leave visual impressions on surfaces. This knowledge can be applied factionary to surfaces to integrate them in the resulting material to fit more convincingly in the final environment.

![alt][Figure06]
> *[Figure06] Left: Floor in a Pub; Mid: burned spots from trampled cigarettes; Right: color variation due to spilled liquids*

The wooden floor of the example is no exclusion to that. The floor is located in a smoking area and in the reference photo are all over the place small dark points like "freckles" on the floor. With a close inspection these freckles are identified burned spots from trampled cigarettes. Another information to consider in a pub is the possibility of spilled liquids. These liquids may not be wiped away immediately, so the liquid will be soaked up from the floor, which can cause discolorations to the wood.



















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
> *[Figure09] Several noises; Left to right: 1D, 2D, 3D; Bottom to top: value, perlin, voronoi; Left: pure noise; Right: fractal Brownian motion based on left sided algorithms*

As shown in [Figure09] the visual appearance of noise can be very different. This is useful in terms of mimicking different natural patterns, where some algorithms are better suited than other. Another consideration of collecting algorithms besides the visual appearance is their application in different dimensions than 2D. One dimensional noises are quite useful when it comes to created color gradients. Their result could either be used to mix defined colors, or their results could control a single color channel. A good example of controlling color channels was made by Inigo Quilez where he used a single  offsetted and scaled cosines function for each channel [IQ04].

## Shapes
While noise algorithms are utilized to mimic unpredictable surface structures, shape algorithms are the complementary solution for geometric structures. These structures will appear likely on man-made surfaces like rooftops or fabrics. But also natural surfaces can show derivatives of geometric forms like leaves or pebbles in mud. To mimic geometric features, algorithms for basic shapes are needed. These algorithms should produce, like noise algorithms, a single value within the range of 0 and 1. Not every complex geometric shape has to be implemented as algorithm. They can be often reassembled by combining basic shapes with boolean operations as subtraction, intersection and union.

![alt][Figure10]
> *[Figure10] Left: various shapes with blur; Right: Distance fields*

An important feature which every shape algorithm has to provide is blur, as shown in [Figure10]. Unfortunately this has to be done within the shape generation, because after the generation there is no way to blur a shape or information without access to neighbor information, which is not given in shader. Blurring shapes is essential for creating procedural materials, because geometric shapes, like noise, have transitions that are represented in various features of a surfaces, where a transition into another height or color is needed. Without blur there would be an instantaneous change in information which do not reflect most surfaces. To provide blurring basic shapes, using a distance field as base is recommended, because then only the start and end point of the transition has to be given. Inigo Quilez made a nice listening of several distance functions in 2D and 3D space on his website [(IQ02)]. Another detail for blurring shapes which should be noticed is that the blur should be linear. A linear gradient will make modifications to the transition distribution easier and exchangeable.

## Easing
Manipulating values is a common element for creating procedural materials. Usually the result of shape and noise algorithms are in the range between 0 and 1. To utilize these results, often their range or distribution has to be adjusted to achieve desired results. This can be either done by scaling and offsetting the result for simple adjustments or the result can be manipulated through easing functions where the results can be very distinguishable from the original input.

![alt][Figure11]
> *[Figure11] Left: Left to right, bottom to top: Exponential, Power, Sinus, Circular; Right: blurred circle as displacement and color with applied easing*

Easing is a well known technique for animations to improve linear interpolation between keyframes to emphasize them. Many algorithms, as mentioned before, will also have gradients within a fixed range. These functions are perfect suited to recreate information like color, height (showed in [Figure11]), basically wherever transitions are.



















# Workflow
Creating procedural materials, algorithms are often used in a repetitive or specific manner to achieve certain results. Techniques and approaches which help creating materials will be part of this section.

## Height first
The most visually perceptible characteristic of surfaces is height. Height influences distortions of reflections, the amount of received light, ambient occlusion, self shadowing and more. Therefore it is a good practice to start off by recreating the height only. Later other features like color or roughness can then derived by the height information. This is possible because many  features depending on the height of the surface, like dust deposits or wearing.

By recreating the height of the surface, information from the analysis should be used. Because the analysis is carried out hierarchical and the the most recognizable features where noticed first, this order should be maintained though the hole creation process. Because when the most recognizable features are done right, it will be no problem to add new and more detailed features without changing the visual appearance. This will also support the hierarchical aspect, because the analysis and height creation can be executed simultaneously in a iterative manner. When the created material will match the requirements, there will be no need for further analyses or detail recreations.

## Distorting parameters
Shape and noise algorithms are the base to reassemble surface structures, but these algorithms may are to to uniform or to poor in details to replicate wanted surface structures. Structures in natural surfaces have often imperfections or turbulences because or reasons like human failure or aging. While it is possible to implement deformations directly into shape and noise algorithms themselves. This approach is not recommended, because this will limit the generating algorithm so specific use cases. To break the perfection or lack of detail of noise and shape algorithms, manipulating their parameters is a efficient and reusable approach. The most interesting parameter to manipulate may be the UV. Manipulating the UV with a noise can easily mimic turbulence or irregularities. [Figure12] showed this technique, where the UV was manipulated multiple times.

![alt][Figure12]
> *[Figure12] manipulated UV with noise for noise: "f(p) = fbm(p + fbm(p + fbm(p)))" [(IQ03)]*

## Seed
As mentioned earlier, the random number generator for procedural materials is based on hashing. Hashing needs an input to create pseudo random numbers. Noise utilize hashing for creating random values, incrementing the input for each new random value which is required. While this is fine and works perfectly, procedural materials can not make use of a single noise only, they have to use  couple of them, noise of different kinds, scale, rotation, offset and values. The risk of using the same noise over and over is to have coincidences by layering or making decisions on them, coincidences like repetitive distribution can be immediately recognized by humans and will break the immersion. Another requirement within procedural materials is the ability to break the continuous structure of noises, this is necessary to mimic surfaces which are made of physically separate but same kind of materials, like floor planks where the planks are from the same type of wood planks but the planks are assembled in a arbitrary order. To ensure the reusability of the algorithms and created sub-materials, every functions which uses hashing in any way should provide a seed parameter. This parameter ensures the diversity of noises, materials and randomness.

## Make more noise
While the base noise functions are useful to create unpredictable patterns, often their appearance is not detailed enough for many purposes. The lack of details is due the limited frequency in the noise. Lattice based noises will have a single frequency projected in their result. Layering the base functions can bring details into noises or create other visual appealing features.

### Fractal Brownian motion
Fractal Brownian motion (fBm) is a well known approach to combine multiple frequencies to create noise rich in details. It describes an additive layering of the same noise algorithm with different weights, scale and iterations. This can be done basically with any noise as shown in [Figure09] on the left side.

### Noise by Noise
The base noise algorithms, even extended by fBm, may do not cover all cases of  unpredictable patterns. To extend the toolbox of noises even more, noise can be combined in any way to create new complex noises for reassembling grunge or other surface features.

![alt][Figure13]
> *[Figure13] Complex noise; Left: complex noise used for displacement and color; Right: generated complex noise from base noise functions*

```glsl
float noise_complex(vec2 point, vec2 seed)
{
    float complex = 1.0;
    for(int i = 0; i < 3; i++)
    {
        float noise = noise_perlin(point, seed++);
        noise = noise_vallies(noise); // --> return abs(noise * 2.0 - 1.0)
        complex = min(complex, noise);
    }

    return easing_power_out(complex, 3.0); // --> return pow(complex, 3.0)
}
```
> Code for the complex noise shown in figure

[Figure13] shows a complex noise which was generated combining the results of base noise functions. This noise also used a single algorithm as base, however there are no restrictions in any way for creating complex noise. Many render applications make use of this technique to provide their users a great selection of patterns. These complex noises can amongst other things mimic surface features like scratches, cracks and grunge.

## Imperfections
TODO: ausformulieren!
By looking to surfaces from the real world, one thing they have all in common: They have all flaws in any way. This is what makes convincing and beliveable surfaces. Ment with flaws are impefections on the surfaces of any size. Examples of imperfections in surfaces are scratches, dents, discolorations, dust, fingerprints or human failure.




















# Applied surface recreation
To prove and show the concepts mentioned above, the floor from the analysis will be recreated as procedural material.

## Planks
In the first iteration the most perceptible features of the floor is recreated. This includes the planks and the wood structure for the planks. To begin the recreation, the order of layers from the analysis is used. Therefore the planks are recreated first.

![alt][Figure14]
> *[Figure14] Left to right: Tilling & scaling, rectangle as height, render, reference photo*

As noticed from the analysis, the planks are a repetitive geometric pattern of rectangles. Placing each plank individually is therefore unpractical, because the material would be through this either limited in size and or also in variation. The applied technique for that which can be seen as first item in [Figure14] is called "tilling". Tilling will be applied to the UV to ensure the texture is endless and every tile has its own individual appearance. The used algorithm takes a continuous UV as input and return on the one hand a fractured UV and on the other hand a two dimensional ID for each tile, which is a very important part that comes later in play. The tilling is applied per axis differently to match the layout of required plank size. In addition to the tilling, every column of planks is randomly shifted to mimic the irregular shift in the photo reference. This UV is then used to draw a rectangle for recreating the basic heightmap. The rectangle which was drawn is seen as second item in [Figure14] and makes use of a small blur with easing, see [Figure11], to mimic the height transition at the border.

![alt][Figure15]
> *[Figure15] Left to right: variation in distortion and tilt, render comparison, reference photo*

The first appearance of the planks is reassembling the layout from the reference phot, but it is not convincing. Besides the lack of detail in many ways, the current appearance of the planks is to perfect. Currently the heightmap describes them as perfectly perpendicular to each other, the edges are perfect straight and every planks is in level and has the same height. This is where environmental influences and imperfections come in play. As wood planks are aging, in this case drying, they will often bend. This can be seen in the reference photo where the distance between the planks will vary. To mimic this, the UV for the planks and the result of the heightmap has been modified. The distortion on the UV reassembles the bend in the XY axes, the modification of the result reassembles the bend in height. In both cases a large scaled perlin noise was used. [Figure15] compares these changes which are subtle, nonetheless improving the plausibility the heightmap.

## Wood material
The creation of the wood material is split in two parts, recording to the analysis and showed in [Figure05].

### Rings
There are several ways to recreate a wood ring pattern. One way to mimic the pattern accurately is to recreate the whole tree trunk with his branches as a three dimensional distance field. A taken cross-section simulates then the saw cut of the log. While recreating material structures as accurate distance field can work out, the computation might be expensive and the implementation complicated. Often it is easier to fake structures to create look a likes which will be convincing enough to trick the viewer. The following process for the structure fake is one of many approaches that will work.

![alt][Figure16]
> *[Figure16] Left to right: scaled noise, first fracture, second fracture, third fracture, combined as fractal Brownian motion*

The fake of the structure starts by stretching a perlin noise in one direction to mimic the run direction of the wood. This noise is then fractured in three different gradations and finally combined as fBm, which reassembles the changing colors of wood rings due to different climatic conditions and summer winter cycles. Another technique to achieve similar patterns is to bring turbulence into the UV which feeds the noise algorithm. Turbulence is added by relative rotations in the UV, controlled by another noise. The showed technique however utilizes only a single noise.

### Branches
The other important recognizable feature of wood are branches, as noticed in the analysis. The shape of branches are often circular, because of that, random placed circles are a good start to mimic them. While the following demonstration will utilize perfect circles, these circles can be manipulated in further iterations to gain more realism.

![alt][Figure17]
> *[Figure17] Left to right: random circles in size and position, wood ring structure, modified structure, modified structure with branches*

To create random placed circles in a endless manner, tilling the underlying UV is necessary. In each created grid is the placed a circle with random position and size. Nonetheless this technique can still appear retentive which will reveal the invisible grid. To conceal that, only a percentage of the circles is drawn, which is determined by random based on the grid id.

The other part of recreating branches in a wood materials is the integration. As mentioned in the analysis, the branches are influencing the layout of the wood rings, where the branches pushes the rings away from them. To trick the viewer again, the UV nearby branches is rotated. Because of that the circles which represent the branches are blurred. The blur is then used as rotation information. Finally the center of the circles and the wood structure is merge together by adding the values. The created heightmap will be the base for further information like albedo or roughness.

## Composition
![alt][Figure18]
> *[Figure18] Left to right: prepared wood material and planks, merged planks with wood, previous render, render with merged wood material*

The composition of the planks and the wood material is applied in two steps. First the material has to utilize the plank UV's, then the heightmap is merged with the height of the planks.

The global UV has been tilled earlies to recreate the planks of the floor. Either the global UV or the plank UV can be used as input for the wood material. Which UV is used will depend on the related effects. While the global UV is in the example untouched, the plank UV is modified to mimic the bending of the planks. Therefore the plank UV is used to take the modifications into the wood material. The UV is equal for every plank and therefore the wood material. To have different version of wood for each plank, the wood material needs a unique seed for each plank. As mentioned earlier, by tilling the UV an id for each plank was created, which is now used as seed.

The information of plank and wood heights is merged by scaling the height of the wood and substracting it from the plank height. This approach provides full control over intensity of the wood structure represented in the planks. Finally the values of the merge heightmap have to be clamped, because the subtracting will cause values below zero between the planks. The approach ensures in addition addition the linearity of the plank and wood height, which would not be given by a multiplication. Nonetheless, the merge algorithm depends on the required result, where the multiplication might be preferred. 

## Deriving from height
As mentioned earlier, the height of the surface is the most perceptible feature of a surface. Therefore the recreation of the surface is the most time consuming part of creating a procedural material. But once created and the structure is establish, all other properties of a surface which have to feed the lightning model can be derived from the height, which takes only a fraction of the effort. The amount of properties and the way of derivation from the heightmap depends on the lightning model. The chosen lightning model is based on Disney's paper for physically based shading [(B01)]. The procedural material will feed the albedo and roughness parameter beside the height displacement.

### Color
The color of the surface of the floor from the example is mainly influenced by two parts. First, by the wood itself and then by the different planks and environment.

![alt][Figure19]
> *[Figure19] Left to right: wood structure, burned cigarette spots, generated surface color, render, reference photo*

Colorizing the wood material is quite straight forward. The generated height is used as interpolation value between two brownish colors which represent the darkest and brightest color of the wood. To refine the distribution between bight and dark colors, the heightmap was eased to show more bright than dark values.

The color information is then utilized by the floor layout, where the existing heightmap of the floor is simply multiplied to the color. This is possible due to specific coincidences. First, the gabs between the planks are filled with deep black dust, which will match the color of the heightmap on this position where the lowest points of the material is represented by zero. Then second coincidence is the height variation of the planks to mimic the bend. Every plank will have a small color variation to other ones, because not every plank is manufactured from the same trunk and position. By multiplying the height information with albedo, the color variation for each plank and the dust is achieved.

Finally the cigarette burns are added to the surface color. The spots are reassembled, like the branches in the wood structure, as circles with random position, size and strength on a tilled UV. This mask is then used to blend between a reddish dark brown, to mimic nearly burned wood, and the existing albedo.

### Roughness
The roughness parameter of the lighting model controls the diffusion of light. In general the floor from the reference photo is a very rough surface because of the shoes from guests. The shoes will cause deposits of dirt and brush up the surface of the wood.

![alt][Figure20]
> *[Figure20] Left to right: Roughness map, render, reference photo*

To simulate the different levels of roughness in the example surface, the heightmap as it is will be utilized, because dirt deposits are located in lower places of the surface. There fore the height is inverted and remapped to cover a small range in the higher level of roughness.

## Further iterations
Once a procedural material feeds all the parameters of the lighting model, further iteration on the details can be made. Right now the example has a comic appearance. This can be improved by using the information from the analysis.
















# Conclusion
The results of the solutions for the named objectives are now analyzed.

## Analyzing surfaces
The analysis of surfaces pointed out to be an essential part of creating procedural materials. The recreation of procedural materials showed that the natural layering and composition of a surface can be transferred into the implementation. Extracted layers from the analysis are corresponding to created UV layouts and general height information, as showed in the example of the pub floor. The splitted analysis of layers and surface materials can be also used to implement surface materials separately to make them reusable for other procedural materials. The wood material from the pub floor could be used also in a furniture material. This will save time and effort by creating such materials. By thinking about environment influences, interesting and characterizing details are added to the material. With these influences, materials are becoming convincing for the viewer. In addition, many environmental influences can be transferred easily to other materials, without the need of reference photos or existing materials. Therefore, some of them can be also prepared as separate material, like cracks or grease, for reuse.

The proposed approach of the analysis showed also to have no dependencies to programming languages or applications. And the restriction for shader programming did not influence the analysis either. Therefore it can be assumed that the approach of the analysis, with its three steps and hierarchical method, can be applied not only to implicit procedural surface creation. The approach may also work for explicit environments and applications like Substance Designer [(SD02)].

## Algorithm categorization
The defined categorization showed to be useful and helpful while creating procedural materials. On the one hand helped the categorization looking for new algorithms to achieve new and distinct results besides the results from existing algorithms, because through the name and appointed task of the categories. On the other hand showed the categorization to be useful by exploring the results of new combinations of algorithms. Due to the sorting of the algorithms is the structure of parameters similar. This made it easy to exchange specific algorithms with other o the same kind to check out new results.

While the analysis showed to be independent from the implementation, the categorization is influenced by the restrictions of shaders. Due to the limitation that only implicit algorithms are suited for shaders, all generative algorithms like noise and shapes depending on UV coordinates. These UV coordinates may are not given in other environments or applications, again like Substance Designer. Therefore the defined categorization might only work for fragment shader implementations.

Nonetheless showed the categorization that through sorting algorithms and implementing them abstract, without specializations, they can be used like Lego bricks. It also abstracts the complexity of the algorithms which makes them usable for a wider range of users and looses creativity from technology.

## Workflow
The proposed workflow guidelines showed to be useful and ensured a structured procedure. The workflow matched also with the hierarchical approach of the analysis, therefore iteration to reach the desired level of detail are built in and are easy to integrate. Similar to the analysis showed the guidelines of the workflow no dependencies to a environment or application, which they may can ne apply to them.

While creating materials, the workflow guidelines showed yet to be vague. And Try-And-Error phases taking still a big portion of the creation process. Foreknowledge of combinations of algorithms cannot be eliminated by the named guidelines. Nonetheless they will help to guide experiments to reach desired results faster.

## General
As showed in the applied recreation, creating procedural materials entirely within a fragment shader will work and can create complex materials with great details. By abstracting the algorithms, it seems that only the creativity might limit the process. Also the restrictions for shaders might not seem to be a big problem. This might be true for the first glance, where also most every structure can be replicated by combining algorithms and or modifying according parameters. On the second glance, it shows that sometimes complex and long chains of algorithms are needed to get desired results, where environments which can utilize post processing algorithms might be way more efficient.

The aspects of performance and anti aliasing also have to be mentioned, even their where not part of this work. Using complex materials entirely created in fragment shaders might not be useful in realtime applications, where every frame per second matters. As showed in the applied recreation, procedural materials are build upon many algorithms which will have an impact on the performance. The approach of procedural material within fragment shaders might work for offline render application, it would be interesting to test how much impact a procedural material will have to the render time besides ordinary textures. The problem with anti aliasing is the level of detail. As more a material gets detail, the more aliasing will appear. Some papers already explored the problem of anti aliasing and discovered approaches to counter it, nonetheless, these techniques have to be implemented to if the aliasing gets to noticeable.














# References
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

[(SD02)]: https://www.substance3d.com/products/substance-designer/
> [(SD02)]: Substance Designer | 2020 | Allegorithmic / Adobe Inc.

[(SD03)]: https://academy.substance3d.com/courses/Creating-your-first-Substance-material/
> [(SD03)]: Substance Designer | 2020 | Allegorithmic / Adobe Inc.





[Figure01]: ./img/earlyNoise.png
[Figure02]: ./img/nodevember.jpg
[Figure03]: ./img/pbrnpr.png
[Figure04]: ./img/planks.png
[Figure05]: ./img/wood.png
[Figure06]: ./img/envi.png
[Figure07]: ./img/uv.png
[Figure08]: ./img/hash.png
[Figure09]: ./img/noise.png
[Figure10]: ./img/shape.png
[Figure11]: ./img/ease.png
[Figure12]: ./img/iqfbm.jpg
[Figure13]: ./img/complex.png
[Figure14]: ./img/applied1.png
[Figure15]: ./img/applied2.png
[Figure16]: ./img/applied3.png
[Figure17]: ./img/applied4.png
[Figure18]: ./img/applied5.png
[Figure19]: ./img/applied6.png
[Figure20]: ./img/applied7.png

>[Figure02]: https://pbs.twimg.com/media/EL857feW4AAiqYr.jpg
