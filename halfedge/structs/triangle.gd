extends Node

var idx = null
var halfEdges = []
var face

func _init(_idx = null):
	if _idx != null:
		idx = _idx
	else:
		idx = -1
		
	halfEdges = []
	face = -1
	
func find_half_edge(top, edge_id):
	var he
	
	for i in halfEdges:
		he = top.halfEdges[i]
		
		if he.edge == edge_id:
			return he
		
	return null
	
func next_half_edge(h_idx):
	var i = halfEdges.find(h_idx)
	
	return halfEdges[(i + 1) % 3]
	
