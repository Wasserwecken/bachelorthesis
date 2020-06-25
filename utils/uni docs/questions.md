# What is the problem
Game and render engines may give the user a interface for creating shaders.
These interfaces often depict only the base functionality of shader languages,
which requires a deep mathematical and functional knowledge by the shader developer
in such applications.


# Why should it be solved
The lack of mathematical and technical knowledge can have a negative impact in creativity, due to
not knowing to accomplish desired results or manipulating values and functions. Which has an
additional negative impact to the development time, because artists and developers have to train
certain skills first to accomplish their final results. Or even worse, their starting to develop
an inefficent or bloated workaround with their current skills.

Another point is the recurrence of algorithms in shaders. The algorithms have to be recreated for
each shader, or if already shadred, to be rewritten or adjusted to new requirements, which can be
negativ to development time, readability and runtime efficiency.


# What is the solution to the problem
Common tasks and catagories can be defined by analysing the workflow of creating textures
and masks in shaders. These analysis is the key to create a libary of abstract predefined functions.
The libary should wrap only basic tasks and algorithms, with no knowledge of their final part in the
shader, solving only a single task or implementing a single algorithm. There should be no uber
function to create a single complex result. 

Due to an abstract and basic design of the functions in the libary, these can be then used like a
construction kit, where the artist or developer can stack and combine the functions, manipulating
their in and outputs to accomplish their desired result.


# What has to be done to solve the problem
The workflow of creating textures and manipulations have to be analysed. So common tasks, algorithms
and categories of manipulations can be defined. The definitions have to be abstract and treat a signle
problem or implementation.

Then, a libary of the defines funtionalities have to be created. This libary will then be used to
create sample textures or shaders to improve, extend and test the libary.


# How do you show that the solution is a good solution to the problem
With a analysis of the created samples can be tested, how many functions how often where used.