@tool class_name ExtrudeMesh3D extends Node3D

@export var path : Path3D:
	set(val):
		if path != null:
			path.curve_changed.disconnect(generate)
		path = val
		path.curve_changed.connect(generate)
@export var shape : PackedVector2Array:
	set(val):
		shape = val
		generate()
@export var sections : int:
	set(val):
		sections = val
		generate()	
@export var materials : Array[Material] = []

var child : MeshInstance3D

func generate():
	if path == null:
		return
	if shape == null:
		return
	if sections < 1: 
		return
	if len(materials) != len(shape)-1:
		return
		
	var len_curve : float = path.curve.get_baked_length()
	var len_section : float = len_curve/sections
	
	var surfaces : Array[PackedVector3Array] = []
	surfaces.resize(len(shape)-1)
	
	var uvs = PackedVector2Array()
	for i in range(sections+1):
		var transform = path.curve.sample_baked_with_rotation(i * len_section, false)
		for j in len(surfaces):
			surfaces[j].append(transform.origin + transform.basis.x * shape[j].x + transform.basis.y * shape[j].y)
			surfaces[j].append(transform.origin + transform.basis.x * shape[j+1].x + transform.basis.y * shape[j+1].y)
		uvs.append(Vector2(0,1-i*len_section/(len_curve)))
		uvs.append(Vector2(1,1-i*len_section/(len_curve)))
		
	var arr_mesh = ArrayMesh.new()
	for surface in surfaces:
		var arrays = []
		arrays.resize(Mesh.ARRAY_MAX)
		arrays[Mesh.ARRAY_VERTEX] = surface
		arrays[Mesh.ARRAY_TEX_UV] = uvs
		# Create the Mesh.
		arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLE_STRIP, arrays)
		
		
	child.mesh = arr_mesh
	for i in range(child.mesh.get_surface_count()):
		child.mesh.surface_set_material(i,materials[i])

	
func _init():
	child = MeshInstance3D.new()
	add_child(child)

func _ready():
	generate()

