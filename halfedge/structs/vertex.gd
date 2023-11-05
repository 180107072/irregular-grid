class_name Vertex

var idx       = null
var userData  = null
var pos       = Vector3.ZERO
var half_edge = -1


func _init(vec: Vector3, _idx = null):
	if _idx != null:
		idx = _idx
	else:
		idx = -1

	pos = vec
