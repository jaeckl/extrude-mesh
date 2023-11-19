class_name ProceduralNetwork extends RefCounted

static func generate_node2(origin : Vector2,edges : Array[NetworkEdge],curve_res : float) -> Mesh:
	edges.sort_custom(func(a : NetworkEdge,b : NetworkEdge): 
		return (-a.direction-origin).angle() > (-b.direction-origin).angle() 
		)
	var vertices = PackedVector2Array()
	# do with line segment connection
	for i in range(len(edges)):
		var j = (i+1)%len(edges)
		var edge0_vect = -edges[i].direction.normalized()*edges[i].distance - origin
		var edge1_vect = -edges[j].direction.normalized()*edges[i].distance - origin
		var side0 = edge0_vect.orthogonal().normalized()
		var side1 = edge1_vect.orthogonal().normalized()
		var v0 = edge0_vect + side0*edges[i].width/2
		var v1 = edge1_vect - side1*edges[j].width/2

		var curve = Curve2D.new()
		curve.bake_interval = curve_res
		curve.add_point(v0,Vector2(0,0),-edge0_vect.normalized()*edges[i].curvein_0)
		curve.add_point(v1,-edge1_vect.normalized()*edges[j].curvein_1,Vector2(0,0))
		vertices.append_array(curve.get_baked_points())

		
	var indices = Geometry2D.triangulate_polygon(vertices)
	if indices.is_empty():
		return null
		
	var vertices_3d = PackedVector3Array()
	
	for index in indices:
		vertices_3d.append(Vector3(vertices[index].x,0,vertices[index].y))
	
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices_3d

	var result = ArrayMesh.new()
	result.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return result

class NetworkEdge:
	var direction : Vector2
	var distance : float
	var width : float
	var curvein_0 : float
	var curvein_1 : float
