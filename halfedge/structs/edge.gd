extends Node


var idx = null
var halfEdge
var aIdx
var bIdx

func _init(a:int, b:int, _idx = null, he = null):
	if _idx == null:
		idx = -1
	else:
		idx = _idx
	
	if he == null:
		he = -1
	else:
		halfEdge = he
	
	aIdx = a
	bIdx = b

func get_triangles(top):
	if halfEdge == -1:
		return null
	
	var a = top.halfEdges[halfEdge]
	
	if a.tri == -1:
		return null
	
	if a.twin != -1:
		var b = top.halfEdges[a.twin]
		if b.tri != -1:
			return [a.tri, b.tri]
	
	
	return [a.tri]
