class_name GeometryExtrusion extends RefCounted

static func generate_extruded_plane(curve : Curve3D,width : float, material : Material) -> Mesh:
	var len_curve : float = curve.get_baked_length()
	var sections : int = len_curve / curve.bake_interval
	
	var vertices = PackedVector3Array()
	var uvs = PackedVector2Array()
	
	for i in range(sections+1):
		var transform = curve.sample_baked_with_rotation(min(i * curve.bake_interval,len_curve), false)
		vertices.append(transform.origin + transform.basis.x * width/2)
		vertices.append(transform.origin - transform.basis.x * width/2)
		uvs.append(Vector2(0,1-i*curve.bake_interval/(len_curve)))
		uvs.append(Vector2(1,1-i*curve.bake_interval/(len_curve)))
		
	
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_TEX_UV] = uvs

	var result = ArrayMesh.new()
	result.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLE_STRIP, arrays)
	
	for i in range(result.get_surface_count()):
		result.surface_set_material(i,material)
	return result

static func generate_extruded_mesh(curve : Curve3D, polygon : Polygon2D,materials : Array[Material]) -> Mesh:
		
	var len_curve : float = curve.get_baked_length()
	var sections : int = len_curve / curve.bake_interval
	var vertices = polygon.polygon
	
	var surfaces : Array[PackedVector3Array] = []
	surfaces.resize(len(vertices))
	
	var uvs = PackedVector2Array()
	for i in range(sections+1):
		var transform = curve.sample_baked_with_rotation(min(len_curve,i * curve.bake_interval), false)
		for j in range(len(surfaces)):
			var offset = transform.basis.x * vertices[j].x + transform.basis.y * vertices[j].y
			surfaces[j].append(transform.origin + offset)
			
			var j_wrap = (j+1) % len(surfaces)
			offset = transform.basis.x * vertices[j_wrap].x + transform.basis.y * vertices[j_wrap].y
			surfaces[j].append(transform.origin + offset)
			
		uvs.append(Vector2(0,1-min(len_curve,i*curve.bake_interval)/(len_curve)))
		uvs.append(Vector2(1,1-min(len_curve,i*curve.bake_interval)/(len_curve)))
		
	var result = ArrayMesh.new()
	
	var indices = Geometry2D.triangulate_polygon(vertices)
	var uvs2 = PackedVector2Array()

	
	var arrays = []

	for surface in surfaces:
		arrays = []
		arrays.resize(Mesh.ARRAY_MAX)
		arrays[Mesh.ARRAY_VERTEX] = surface
		arrays[Mesh.ARRAY_TEX_UV] = uvs
		# Create the Mesh.
		result.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLE_STRIP, arrays)
	
	for i in range(result.get_surface_count()):
		result.surface_set_material(i,materials[i])
	
	return result
