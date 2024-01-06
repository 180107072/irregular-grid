@tool
extends Node3D


var button_presses := {}
var time := 0.0
var time2 := 0.0
var time3 := 0.0
var time_text := 0.0
var debug = Debug.new()

func _ready() -> void:

	await get_tree().process_frame

func _process(_delta):
	pass


