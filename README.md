# Godot 4 Project - EvoSimulation

v0.0.1, by MeniMato.

This is a small evolution simulation made using Godot 4. There are 3 types of critters:

+ Producer 1
+ Consumer 1
+ Consumer 2

In this scenario, Producer 1 is eaten by Consumer 1, which is eaten by Consumer 2. Consumers 1 and 2 have a "brain" that is a simple [MLP](https://en.wikipedia.org/wiki/Multilayer_perceptron) with no activation function, with an input made of 19 units, a hidden layer of 8 units, and an output of 2 units. An input is the collision distance alongside an array of RayCast2D, while the outputs are angular and linear velocity, respectively.

Simulation defining parameters can be changed in `GlobalScript.gd`.

The brain inspector show positive values in red and negative values in blue. Channel thickness is relative to its value.

You can use and modify the source code in any way you want. Giving credit is not necessary, but highly appreciated.