@tool
extends Path3D

@export var reduction : float:
	set(val):
		reduction = val
		reduce_curve_back(reduction)

func reduce_curve_back(offset : float):
	var old_curve = (get_parent().get_child(0) as Path3D).curve as Curve3D
	var new_curve = old_curve.duplicate() as Curve3D
	var p0 = old_curve.get_point_position(0)
	var p1 = old_curve.get_point_out(0)+ old_curve.get_point_position(0)
	var p2 = old_curve.get_point_in(1) + old_curve.get_point_position(1)
	var p3 = old_curve.get_point_position(1)
	var t = offset/old_curve.get_baked_length()
	var p11 = (1-t)*p1+t*p0
	var p21 = (1-t)*p2+t*p1
	var p31 = (1-t)*p3+t*p2
	var p4 = (1-t)*p21+t*p11
	var p5 = (1-t)*p31+t*p21
	var pp = (1-t)*p5+t*p4
	new_curve.set_point_out(0,p11-p0)
	new_curve.set_point_in(1, p4-pp)
	new_curve.set_point_position(1,pp)
	curve = new_curve

