extends Node2D

func _ready():
	$CanvasLayer/CenterContainer/VBoxContainer/Start.pressed.connect(start_simulation)

func start_simulation():
	GlobalScript.max_creator1 = $CanvasLayer/CenterContainer/VBoxContainer/Maxes/max_creator1.value
	GlobalScript.max_consumer1 = $CanvasLayer/CenterContainer/VBoxContainer/Maxes/max_consumer1.value
	GlobalScript.max_consumer2 = $CanvasLayer/CenterContainer/VBoxContainer/Maxes/max_consumer2.value
	
	get_tree().change_scene_to_file("res://Nodes/main.tscn")
	self.queue_free()
