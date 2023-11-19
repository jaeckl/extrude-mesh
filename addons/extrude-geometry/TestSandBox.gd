@tool
class_name TestSandBox extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var edges : Array[ProceduralNetwork.NetworkEdge]
	var a0 = ProceduralNetwork.NetworkEdge.new()
	a0.direction = Vector2(-1,0)
	a0.distance = 6
	a0.width = 4
	a0.curvein_0 = 4
	a0.curvein_1 = 0
	
	var a1 = ProceduralNetwork.NetworkEdge.new()
	a1.direction = Vector2(1,0)
	a1.distance = 6
	a1.width = 4
	a1.curvein_0 = 0
	a1.curvein_1 = 0
	
	var a2 = ProceduralNetwork.NetworkEdge.new()
	a2.direction = Vector2(0.5,0.5)
	a2.distance = 6
	a2.width = 4
	a2.curvein_0 = 1
	a2.curvein_1 = 0
	
	edges.append(a0)
	edges.append(a1)
	edges.append(a2)
	
	var child = MeshInstance3D.new()
	child.mesh = ProceduralNetwork.generate_node2(Vector2(0,0),edges,0.1)
	add_child(child)
