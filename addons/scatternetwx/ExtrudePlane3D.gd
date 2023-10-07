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
		
@export var sections : int:
	set(val):
		sections = val
		generate()		
@export var shader_mat : ShaderMaterial = preload("res://addons/scatternetwx/materials/placeholder_material_street.tres")

var child : MeshInstance3D

func generate():
	if path == null:
		return
	if path.curve == null:
		return
	if sections == 0:
		return
	if width == 0:
		return

	var len_curve : float = path.curve.get_baked_length()
	var len_section : float = len_curve/sections
	
	var vertices = PackedVector3Array()
	var uvs = PackedVector2Array()
	for i in range(sections+1):
		var transform = path.curve.sample_baked_with_rotation(i * len_section, false)
		vertices.append(transform.origin + transform.basis.x * width/2)
		vertices.append(transform.origin - transform.basis.x * width/2)
		uvs.append(Vector2(0,1-i*len_section/(len_curve)))
		uvs.append(Vector2(1,1-i*len_section/(len_curve)))
	# Initialize the ArrayMesh.
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_TEX_UV] = uvs
	# Create the Mesh.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLE_STRIP, arrays)
	
	child.mesh = arr_mesh
	shader_mat.set_shader_parameter("repetition",float(len_curve/width))
	for i in range(child.mesh.get_surface_count()):
		child.mesh.surface_set_material(i,shader_mat)

func _init():
	child = MeshInstance3D.new()
	add_child(child)

func _ready():
	generate()
	
static func generate_extruded_plane(curve : Curve3D,bake_interval : float, width : float, material : Material) -> Mesh:
	var len_curve : float = curve.get_baked_length()
	var sections : int = len_curve / bake_interval
	var vertices = PackedVector3Array()
	var uvs = PackedVector2Array()
	for i in range(sections+1):
		var transform = curve.sample_baked_with_rotation(min(i * bake_interval,len_curve), false)
		vertices.append(transform.origin + transform.basis.x * width/2)
		vertices.append(transform.origin - transform.basis.x * width/2)
		uvs.append(Vector2(0,1-i*bake_interval/(len_curve)))
		uvs.append(Vector2(1,1-i*bake_interval/(len_curve)))
		
	
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_TEX_UV] = uvs

	var result = ArrayMesh.new()
	result.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLE_STRIP, arrays)
	
	for i in range(result.get_surface_count()):
		result.surface_set_material(i,material)
	return result
