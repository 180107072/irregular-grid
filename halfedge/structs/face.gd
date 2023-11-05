class_name Face

var idx        = null
var half_edges = null


func _init(_idx = null):
	if _idx != null:
		idx = _idx
	else:
		idx = -1

	half_edges = []


func _into_array(n):
	var a = []
	for i in range(0, n):
		a.append(0)
	return a


func get_vertices(top: Topology, out = null):
	if out == null:
		out = _into_array(half_edges.size())
	var o = []
	for i in range(0, half_edges.size()):
		o.push_back(top.vertices[top.half_edges[half_edges[i]].vertex])

	return o
