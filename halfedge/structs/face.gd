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
	for i in range(0, n):
		a.append(0)
	return a

func get_vertices(top, out = null):
	if out == null:
		out = _into_array(halfEdges.size())
	var o = []
	for i in range(0, halfEdges.size()):
		o.push_back( top.vertices[ top.halfEdges[ halfEdges[ i ] ].vertex ])
		
	
	return o
