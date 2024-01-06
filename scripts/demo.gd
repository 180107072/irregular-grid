extends Node3D

var debug = Debug.new()
func _ready():
	var irr_grid = IrregularHexGrid.new()
	var grid = irr_grid.build(15, 20, 3, 0.2)
	for f in grid.faces:

		var edg = grid.half_edges[f.half_edges[0]]
		var length = f.half_edges.size()

		for i in range(1, length + 1):
			var ii = i % length
			
			var nex = grid.half_edges[f.half_edges[ii]]
			var mesh = debug.line(grid.get_vert_pos( edg.vertex ), grid.get_vert_pos( nex.vertex ))
			add_child(mesh)
			edg = nex
