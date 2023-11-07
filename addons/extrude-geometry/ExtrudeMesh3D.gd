@tool class_name ExtrudeMesh3D extends Node3D

@export var path : Path3D:
	set(val):
		if path != null:
			path.curve_changed.disconnect(generate)
		path = val
		path.curve_changed.connect(generate)
@export var polygon : Polygon2D:
	set(val):
		if polygon != null:
			polygon.item_rect_changed.disconnect(generate)
		polygon = val
		polygon.item_rect_changed.connect(generate)
		generate()
@export var materials : Array[Material] = []

var child : MeshInstance3D

func generate():
	if path == null:
		return
	if polygon == null:
		return

	child.mesh = GeometryExtrusion.generate_extruded_mesh(path.curve, polygon,materials)

	
func _init():
	child = MeshInstance3D.new()
	add_child(child)

func _ready():
	generate()

