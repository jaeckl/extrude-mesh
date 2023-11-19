 # Procedural Generation Of Network Nodes

 Simulation games like "Cities Skylines" feature building tools that allow the user the development of street networks. This is done by letting the user manually draw a curve on the world surface. Along the curve a mesh is getting extruded on which a road texture is rendered. Multiple curces can be connected via a node to procude a procedural crossing. The goal of this document is to find a implementation approach for procedurally generating such a crossing.

## Modelling
### Data Structures
The procedure computing the mesh of the network node should receive an array of edges as input parameter. Each edge should be defined by the following attributes:

```puml
!theme cyborg-outline
!define BBT(text) <b><color:lightblue>text</color></b>
class NetworkEdge {
    incoming_direction  BBT(Vector2) 
    attachment_distance BBT(float)
    edge_width BBT(float)
}

hide methods
hide circle
skinparam BackgroundColor transparent
skinparam DefaultFontName Arial
skinparam DefaultFontColor white
```
The network node itself is just defined by its center point:

```puml
!theme cyborg-outline
!define BBT(text) <b><color:lightblue>text</color></b>
class NetworkNode {
    center_point  BBT(Vector2) 
}
hide methods
hide circle
skinparam BackgroundColor transparent
skinparam DefaultFontName Arial
skinparam DefaultFontColor white
```

### Process Description

The basic idea of my algorithm for generating the geometry can be split into steps:

```puml
!theme cyborg-outline
start
: Sort NetworkEdges   ;
while (Has Next NetworkEdge)
    : Create Polygon Edge;
    : Connect Polygon Edge;
endwhile
end
hide methods
hide circle
skinparam BackgroundColor transparent
skinparam DefaultFontName Arial
skinparam DefaultFontColor white
```

**Sort NetworkEdges:** This is a preprocessing step. It is necessary since the given NetworkEdges might not be input ordered circular around the around the GraphNode center_point. 

**Create Polygon Edge:** Here we create the geometry for the edge where a the NetworkEdge would be attached to.

**Connect Polygon Edge:** He we connect the new created edge with the edge that was created before