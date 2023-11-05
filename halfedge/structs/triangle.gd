class_name Triangle

var idx        = null
var half_edges = []
var face       = null


func _init(_idx = null):
	if _idx != null:
		idx = _idx
	else:
		idx = -1

	half_edges = []
	face = -1


func find_half_edge(top: Topology, edge_id: int):
	for i in half_edges:
		var he = top.half_edges[i]

		if he.edge == edge_id:
			return he

	return null


func next_half_edge(h_idx):
	var i = half_edges.find(h_idx)

	return half_edges[(i + 1) % 3]
