@tool
extends Node3D

@export var custom_font : Font
@export var zylann_example := false
@export var test_text := true
@export var test_graphs := false
@export var more_test_cases := true
@export var draw_array_of_boxes := false
@export_range(0, 1024) var start_culling_distance := 0.0

@export_group("Text groups", "text_groups")
@export var text_groups_show_hints := true
@export var text_groups_show_stats := false
@export var text_groups_show_stats_2d := false
@export var text_groups_position := DebugDrawConfig2D.POSITION_LEFT_TOP
@export var text_groups_offset := Vector2i(8, 8)
@export var text_groups_padding := Vector2i(3, 1)
@export_range(1, 100) var text_groups_default_font_size := 12
@export_range(1, 100) var text_groups_title_font_size := 14
@export_range(1, 100) var text_groups_text_font_size := 12

@export_group("Graphs", "graph")
@export var graph_offset := Vector2i(8, 8)
@export var graph_size := Vector2i(200, 80)
@export_range(1, 100) var graph_title_font_size := 14
@export_range(1, 100) var graph_text_font_size := 12
@export_range(0, 64) var graph_text_precision := 2
@export_range(1, 32) var graph_line_width := 1.0
@export_range(1, 512) var graph_buffer_size := 128
@export var graph_frame_time_mode := true
@export var graph_is_enabled := true

var button_presses := {}
var time := 0.0
var time2 := 0.0
var time3 := 0.0
var time_text := 0.0

var IrregularGrid = preload("res://grid/irregular_hex_grid.gd").new()
var created = false
var grid = IrregularGrid.create()

func _ready() -> void:
	_update_keys_just_press()
	
	await get_tree().process_frame
	
	# this check is required for inherited scenes, because an instance of this 
	# script is created first, and then overridden by another
	if !is_inside_tree():
		return


func _is_key_just_pressed(key):
	if (button_presses[key] == 1):
		button_presses[key] = 2
		return true
	return false


func _update_keys_just_press():
	var set_key = func (k: Key): return (1 if button_presses[k] == 0 else button_presses[k]) if Input.is_key_pressed(k) else 0
	button_presses[KEY_LEFT] = set_key.call(KEY_LEFT)
	button_presses[KEY_UP] = set_key.call(KEY_UP)
	button_presses[KEY_F1] = set_key.call(KEY_F1)
	button_presses[KEY_1] = set_key.call(KEY_1)
	button_presses[KEY_2] = set_key.call(KEY_2)
	button_presses[KEY_3] = set_key.call(KEY_3)


func _process(delta: float) -> void:
	for f in grid.faces:
		var edg = grid.halfEdges[f.halfEdges[0]]
		var len = f.halfEdges.size()
		var box_pos = Vector3(0, 0, 0)
		DebugDraw3D.draw_box(box_pos, Vector3(1, 2, 1), Color(0, 1, 0))
		for i in range(0, len):
			var ii = i % len
			var nex = grid.halfEdges[f.halfEdges[ii]]
			DebugDraw3D.draw_line(grid.get_vert_pos( edg.vertex ), grid.get_vert_pos( nex.vertex ) , Color(255, 255, 255))
			edg = nex

	_update_keys_just_press()



