extends Node

var idx = null
var halfEdges


func _init(_idx = null):
	if _idx != null:
		idx = _idx
	else:
		idx = -1
		
	halfEdges = []
	
func _into_array(n):
	var a = []
	for i in range(0, n - 1):
		a.append(0)
	return a

func get_vertices(top, out = null):
	if out == null:
		out = _into_array(halfEdges.size())
	
	for i in range(0, halfEdges.size() - 1):
		out[i] = top.vertices[top.halfEdges[halfEdges[i]].vertex]
	
	return out
