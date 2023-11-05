class_name Cell

var idx
var faceIdx
var pos
var points
var localPoints
var userData

func _init(_idx, _fIdx, _pos):
	idx = _idx
	faceIdx = _fIdx
	pos = _pos
	points = null
	localPoints = null
	userData = {}
