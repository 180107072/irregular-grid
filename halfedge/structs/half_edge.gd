class_name HalfEdge

var idx = null
var twin

var vertex = -1
var edge   = -1
var tri    = -1
var face   = -1

var triPrev  = -1
var triNext  = -1
var facePrev = -1
var faceNext = -1


func _init(_idx = null, _twin = null):
	if _idx == null:
		idx = -1
	else:
		idx = _idx

	if _twin == null:
		twin = -1
	else:
		twin = _twin


func get_opposite_vertex(top: Topology, v_idx):
	var edg = top.edges[edge]
	if edg.aIdx != v_idx:
		return edg.aIdx
	else:
		return edg.bIdx
