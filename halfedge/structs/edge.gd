class_name Edge

var idx       = null
var half_edge = null
var aIdx      = null
var bIdx      = null


func _init(a: int, b: int, _idx = null, he = null):
	if _idx == null:
		idx = -1
	else:
		idx = _idx

	if he == null:
		he = -1
	else:
		half_edge = he

	aIdx = a
	bIdx = b


func get_triangles(top: Topology):
	if half_edge == -1:
		return null

	var a = top.half_edges[half_edge]

	if a.tri == -1:
		return null

	if a.twin != -1:
		var b = top.half_edges[a.twin]
		if b.tri != -1:
			return [a.tri, b.tri]

	return [a.tri]
