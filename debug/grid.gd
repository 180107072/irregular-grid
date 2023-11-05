extends Node

var grid = null

func _init(_grid):
	grid = _grid

func debug_faces():
	for f in grid.faces:

		var edg = grid.half_edges[f.half_edges[0]]
		var length = f.half_edges.size()

		for i in range(1, length + 1):
			var ii = i % length
			
			var nex = grid.half_edges[f.half_edges[ii]]
			DebugDraw3D.draw_line(grid.get_vert_pos( edg.vertex ), grid.get_vert_pos( nex.vertex ) , Color(255, 255, 255))
			edg = nex
