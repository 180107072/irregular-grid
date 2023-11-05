extends Node
const Point = preload("res://grid/structs/point.gd")
const Cell = preload("res://grid/structs/cell.gd")
var OPS_Face = preload("res://halfedge/ops/ops_face.gd").new()

var cells = []
var points = []
var topology = null

func from_topology(top, h_step = 0, cell_cnt = 3):
	var idx = 0
	
	topology = top
	
	var p 
	var pnt
	
	for o in top.vertices:
		o.userData = []
		for i in range(0, cell_cnt):
			p = o.pos
			
			p.y += i * h_step
			
			var pnt_idx = idx + 1
			pnt = Point.new(pnt_idx, o.idx, p)
			
			points.push_back(pnt)
			
			o.userData.push_back(pnt)
	
	var halfStep = h_step * 0.5
	
	var cell
	
	var pnts
	
	var center = Vector3.ZERO
	
	for o in top.faces:
		pnts = OPS_Face.face_vertices(top, o.idx)
		center += pnts[0].pos + pnts[1].pos + pnts[2].pos + pnts[3].pos
		
		center *= 0.25
		
		for i in range(0, cell_cnt):
			pnt = Vector3(center)
			pnt.y += halfStep + i * h_step;
			
			var c_idx = idx + 1
			cell = Cell.new(c_idx, o.idx, pnt)
			
			# todo cells
		
		
	return self
