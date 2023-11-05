@tool
extends Node3D


var button_presses := {}
var time := 0.0
var time2 := 0.0
var time3 := 0.0
var time_text := 0.0

var IrregularGrid = preload("res://grid/irregular_hex_grid.gd").new()
var created = false
var grid

func _ready() -> void:
	await get_tree().process_frame
	grid = IrregularGrid.create()


func _process(delta: float) -> void:
	for f in grid.faces:

		var edg = grid.halfEdges[f.halfEdges[0]]
		var length = f.halfEdges.size()

		for i in range(1, length + 1):
			var ii = i % length
			
			var nex = grid.halfEdges[f.halfEdges[ii]]
			DebugDraw3D.draw_line(grid.get_vert_pos( edg.vertex ), grid.get_vert_pos( nex.vertex ) , Color(255, 255, 255))
			edg = nex



