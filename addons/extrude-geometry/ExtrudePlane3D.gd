@tool
class_name ExtrudePlane3D extends Node3D

@export var path : Path3D:
	set(val):
		if path != null:
			path.curve_changed.disconnect(generate)
		path = val
		path.curve_changed.connect(generate)
		
@export var width : float:
	set(val):
		width = val
		generate()
		
@export var material : ShaderMaterial:
	set(val):
		material = val
		generate()

var child : MeshInstance3D

func generate():
	if path == null:
		return
	if path.curve == null:
		return
	if width == 0:
		return
	if material == null:
		return

	material.set_shader_parameter("repetition",float(path.curve.get_baked_length()/width))
	child.mesh = GeometryExtrusion.generate_extruded_plane(path.curve,1,material)


func _init():
	child = MeshInstance3D.new()
	add_child(child)

func _ready():
	generate()
	

