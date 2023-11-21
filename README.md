## Extrusion Geometry
This plugin provides a simple script for extruding a plane or polygon along a curve. With easy to use nodes that include editor editability.
![](./_doc/media.gif)
### Content
- The `GeometryExtrusion` script
- Two new node types `ExtrusionPlan3D` and `ExtrusionMesh3D`
- An example scene that presents the new node types
- A basic curve length aware shader

### The New Nodes

<hr>

#### ExtrudePlane3D
The `ExtrudePlane3D` node lets you extrude a plane along a `Path3D` node. The number of triangles used for the mesh is dependent on the bake interval of the `Path3D` curve.

A `ExtrudePlane3D` has three attributes:
- Path3D path

The path used for generating the extruded geometry.

- float width

The width of the generated geometry orthogonal to the paths direction.

- ShaderMaterial material

The material used for the generated geometry. The generated UV map streches along the entire width and length of the generated geometry. A new shader must export the shader parameter "repetition" which is of type `int`.

<hr>

#### ExtrudeMesh3D
The `ExtrudePlane3D` node lets you extrude a `Polygon2D` along a `Path3D` node. The number of triangles used for the mesh is dependent on the bake interval of the `Path3D`curve.

A `ExtrudeMesh3D` has three attributes:
- Path3D path

The path used for generating the extruded geometry.

- float polygon

The polygon which will get extruded. Each edge will get extruded along the path.

- Array[ShaderMaterial] materials

The materials used for the generated geometry. The generated UV map streches along the entire width and length of the generated geometry. The index of each material corresponds with each edge of the `Polygon2D`

## Disclaimer
This project is not in active development. For me it is just a creative side project. I won't update or add new features regularly. While my goal is to create some 'Cities Skylines' like road building tool for the Godot Game Engine this is not a the repository that I will update regularly.
