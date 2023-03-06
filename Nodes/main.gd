extends Node2D

var max_creator1 = 1500
var max_consumer1 = 300
var max_consumer2 = 150

var show_gen = false
var node_showing_brain

func _ready():
	max_creator1 = GlobalScript.max_creator1
	max_consumer1 = GlobalScript.max_consumer1
	max_consumer2 = GlobalScript.max_consumer2
	
	multiple_spawns(GlobalScript.ID_PRODUCER_1)
	multiple_spawns(GlobalScript.ID_CONSUMER_1)
	multiple_spawns(GlobalScript.ID_CONSUMER_2)
	
	$CanvasLayer/UI.pressed.connect(show_hide_controls)
	
	$CanvasLayer/VBoxContainer/ToggleButtons/add_producer1.pressed.connect(toggle_pressed.bind($CanvasLayer/VBoxContainer/ToggleButtons/add_producer1))
	$CanvasLayer/VBoxContainer/ToggleButtons/add_consumer1.pressed.connect(toggle_pressed.bind($CanvasLayer/VBoxContainer/ToggleButtons/add_consumer1))
	$CanvasLayer/VBoxContainer/ToggleButtons/add_consumer2.pressed.connect(toggle_pressed.bind($CanvasLayer/VBoxContainer/ToggleButtons/add_consumer2))
	
	$CanvasLayer/VBoxContainer/Misc/show_brain.pressed.connect(toggle_inspect_brain)
	
	$CanvasLayer/VBoxContainer/GeneralSpawn/SpawnProducer1.pressed.connect(multiple_spawns.bind(GlobalScript.ID_PRODUCER_1))
	$CanvasLayer/VBoxContainer/GeneralSpawn/SpawnConsumer1.pressed.connect(multiple_spawns.bind(GlobalScript.ID_CONSUMER_1))
	$CanvasLayer/VBoxContainer/GeneralSpawn/SpawnConsumer2.pressed.connect(multiple_spawns.bind(GlobalScript.ID_CONSUMER_2))
	
	$CanvasLayer/VBoxContainer/Misc/ToggleGen.pressed.connect(toggle_generation_label)
	
	$CanvasLayer/VBoxContainer/Back.pressed.connect(back_to_start)
	
func _process(_delta):
	$CanvasLayer/VBoxContainer/FPS.text = str(Engine.get_frames_per_second()) + ' FPS\nProducer1: '+str($all_creator_1.get_child_count())+'\nConsumer1: '+str($all_consumer_1.get_child_count())+'\nConsumer2: '+str($all_consumer_2.get_child_count())
	if $CanvasLayer/Inspector.visible and $CanvasLayer/Inspector.node_showing_brain!=null:
		$ShowingBrain.visible=true
		$ShowingBrain.position = $CanvasLayer/Inspector.node_showing_brain.position
	else:
		$ShowingBrain.visible=false
	
func toggle_pressed(pressed_node):
	var aux = pressed_node.button_pressed
	for n in $CanvasLayer/VBoxContainer/ToggleButtons.get_children():
		n.set_pressed(false)
	pressed_node.set_pressed(aux)
	
func toggle_inspect_brain():
	$CanvasLayer/Inspector.visible = $CanvasLayer/VBoxContainer/Misc/show_brain.button_pressed
	if node_showing_brain != null:
		node_showing_brain.showing_brain = $CanvasLayer/VBoxContainer/Misc/show_brain.button_pressed

func add_consumer_1(pos:Vector2):
	var consumer_1 = load("res://Nodes/consumer_1.tscn").instantiate()
	consumer_1.position = pos
	consumer_1.get_node('GenCounter').visible = show_gen
	consumer_1.type_ = GlobalScript.ID_CONSUMER_1
	$all_consumer_1.add_child(consumer_1)
	
func add_consumer_2(pos:Vector2):
	var consumer_2 = load("res://Nodes/consumer_2.tscn").instantiate()
	consumer_2.position = pos
	consumer_2.get_node('GenCounter').visible = show_gen
	consumer_2.type_ = GlobalScript.ID_CONSUMER_2
	$all_consumer_2.add_child(consumer_2)

func add_producer_1(pos):
	var creator_1 = load("res://Nodes/producer_1.tscn").instantiate()
	creator_1.position = pos
	$all_creator_1.add_child(creator_1)

func multiple_spawns(type):
	if type==GlobalScript.ID_PRODUCER_1:
		for i in range(max_creator1*.3):
			add_producer_1(Vector2(randf_range(0,DisplayServer.window_get_size().x), randf_range(0,DisplayServer.window_get_size().y)))
	elif type==GlobalScript.ID_CONSUMER_1:
		for i in range(max_consumer1*.3):
			add_consumer_1(Vector2(randf_range(0,DisplayServer.window_get_size().x), randf_range(0,DisplayServer.window_get_size().y)))
	elif type==GlobalScript.ID_CONSUMER_2:
		for i in range(max_consumer2*.3):
			add_consumer_2(Vector2(randf_range(0,DisplayServer.window_get_size().x), randf_range(0,DisplayServer.window_get_size().y)))

func toggle_generation_label():
	show_gen = $CanvasLayer/VBoxContainer/Misc/ToggleGen.button_pressed
	
	var nodes = $all_consumer_1.get_children()
	for n in nodes:
		if n is RigidBody2D:
			if n.type_!=0:
				n.get_node('GenCounter').visible = show_gen
				
	nodes = $all_consumer_2.get_children()
	for n in nodes:
		if n is RigidBody2D:
			if n.type_!=0:
				n.get_node('GenCounter').visible = show_gen

func _input(_event):
	var mouse_pos = get_global_mouse_position()
	var vbc = $CanvasLayer/VBoxContainer
	if (Input.is_action_just_pressed("click") and
	((mouse_pos.x<vbc.position.x or mouse_pos.x>vbc.position.x+vbc.size.x) or 
	(mouse_pos.y<vbc.position.y or mouse_pos.y>vbc.position.y+vbc.size.y))):
		if $CanvasLayer/VBoxContainer/ToggleButtons/add_producer1.button_pressed:
			add_producer_1(mouse_pos)
		elif $CanvasLayer/VBoxContainer/ToggleButtons/add_consumer1.button_pressed:
			add_consumer_1(mouse_pos)
		elif $CanvasLayer/VBoxContainer/ToggleButtons/add_consumer2.button_pressed:
			add_consumer_2(mouse_pos)

func show_hide_controls():
	$CanvasLayer/VBoxContainer.visible = $CanvasLayer/UI.button_pressed
	$CanvasLayer/Panel.visible = $CanvasLayer/UI.button_pressed

func back_to_start():
	get_tree().change_scene_to_file("res://Nodes/start.tscn")
	self.queue_free()
