extends RigidBody2D

@export var type_:int
var food_to_reproduce:int = 100
var speed = 20.0
var speed_ang = 2*PI

var generation = 1
var showing_brain = false

var food = 0.0

var input = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]

var output = [0.0, 0.0] # 0: linear vel 1: angular vel
	
var brain = {'B1': [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0],
			'C1': [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
				[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
				[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
				[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
				[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
				[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
				[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
				[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
				[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
				[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
				[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
				[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
				[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
				[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
				[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
				[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
				[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
				[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
				[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]],
			'B2': [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
			'C2': [[0.0, 0.0],
				[0.0, 0.0],
				[0.0, 0.0],
				[0.0, 0.0],
				[0.0, 0.0],
				[0.0, 0.0],
				[0.0, 0.0],
				[0.0, 0.0]],
			'B3': [0.0, 0.0]}

var is_offspring = false
var negative_input_type = -1

func _ready():
	if type_==GlobalScript.ID_CONSUMER_1:
		food_to_reproduce = GlobalScript.food_required_to_reproduce_consumer_1
		negative_input_type = GlobalScript.consumer_1_negative_input
		$TimerLife.set_wait_time(randf_range(GlobalScript.consumer_1_min_TimerLife, GlobalScript.consumer_1_max_TimerLife))
		$TimerReproduce.set_wait_time(randf_range(GlobalScript.consumer_1_min_TimerReproduce, GlobalScript.consumer_1_max_TimerReproduce))
	elif type_==GlobalScript.ID_CONSUMER_2:
		food_to_reproduce = GlobalScript.food_required_to_reproduce_consumer_2
		negative_input_type = GlobalScript.consumer_2_negative_input
		$TimerLife.set_wait_time(randf_range(GlobalScript.consumer_2_min_TimerLife, GlobalScript.consumer_2_max_TimerLife))
		$TimerReproduce.set_wait_time(randf_range(GlobalScript.consumer_2_min_TimerReproduce, GlobalScript.consumer_2_max_TimerReproduce))
	$TimerLife.start()
	$TimerReproduce.start()
	
	if is_offspring:
		if type_==GlobalScript.ID_CONSUMER_1:
			random_genes(GlobalScript.consumer_1_mutation_rate)
		elif type_==GlobalScript.ID_CONSUMER_2:
			random_genes(GlobalScript.consumer_2_mutation_rate)
	else:
		random_genes(100)
		$Body.color = Color(randf_range(0,1), randf_range(0,1), randf_range(0,1))
		$Contour.color = Color(randf_range(0,1), randf_range(0,1), randf_range(0,1))
	
	$GenCounter.text = str(generation)

var new_position = Vector2(0, 0)
var should_reset = false
func _integrate_forces(state):
	if should_reset:
		state.transform.origin = new_position
		should_reset = false

func _process(_delta):
	output = compute_output()
	
	angular_velocity = output[1]*speed_ang
	# rotation = output[1]*speed_ang
	linear_velocity = Vector2(0.0, output[0]*speed).rotated(rotation)
	
	vision()
	
	if position.x>DisplayServer.window_get_size().x:
		new_position = position
		new_position.x = 0
		should_reset=true
	if position.y>DisplayServer.window_get_size().y:
		new_position = position
		new_position.y = 0
		should_reset=true
	if position.x<0:
		new_position = position
		new_position.x = DisplayServer.window_get_size().x
		should_reset=true
	if position.y<0:
		new_position = position
		new_position.y = DisplayServer.window_get_size().y
		should_reset=true

func random_genes(rand_percent:int):
	for i in range(len(brain.B1)):
		if randi_range(0,100)<=rand_percent:
			brain.B1[i] = randf_range(-1.0, 1.0)
	for i in range(len(brain.C1)):
		for j in range(len(brain.C1[i])):
			if randi_range(0,100)<=rand_percent:
				brain.C1[i][j] = randf_range(-1.0, 1.0)
	for i in range(len(brain.B2)):
		if randi_range(0,100)<=rand_percent:
			brain.B2[i] = randf_range(-1.0, 1.0)
	for i in range(len(brain.C2)):
		for j in range(len(brain.C2[i])):
			if randi_range(0,100)<=rand_percent:
				brain.C2[i][j] = randf_range(-1.0, 1.0)
	for i in range(len(brain.B3)):
		if randi_range(0,100)<=rand_percent:
			brain.B3[i] = randf_range(-1.0, 1.0)

func vision():
	var rays = $Rays.get_children()
	rays.sort()
	for i in range(len(rays)):
		if rays[i].is_colliding():
			update_input(rays[i], i)
		else:
			input[i] = 0.0
		
func update_input(raycast:RayCast2D, ind:int):
	if raycast.get_collider() != null:
		if raycast.get_collider().type_ == type_:
			return
		var origin = raycast.global_transform.origin
		var collision_point = raycast.get_collision_point()
		var distance = -raycast.target_position.y-origin.distance_to(collision_point)
		if raycast.get_collider().type_ == negative_input_type:
			distance = distance*-1
		input[ind] = float(distance)/(-raycast.target_position.y)

func compute_output():
	var A3
	if showing_brain:
		#
		var A1 = input.duplicate(true)
		#
		var A2 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
		var C1 = []
		for i in range(len(A2)):
			var c1 = []
			for j in range(len(A1)):
				A2[i] = A2[i]+(A1[j]*brain.C1[j][i])
				c1.append(A1[j]*brain.C1[j][i])
			C1.append(c1)
		for i in range(len(A2)):
			A2[i] = A2[i]+brain.B1[i]
		#
		A3 = [0.0, 0.0]
		var C2 = []
		for i in range(len(A3)):
			var c2 = []
			for j in range(len(A2)):
				A3[i] = A3[i]+(A2[j]*brain.C2[j][i])
				c2.append(A2[j]*brain.C2[j][i])
			C2.append(c2)
		for i in range(len(A3)):
			A3[i] = A3[i]+brain.B2[i]
		#
		get_node('../../CanvasLayer/Inspector').update_inspector(A1, A2, A3, C1, C2)
	else:
		#
		var A1 = input.duplicate(true)
		#
		var A2 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
		for i in range(len(A2)):
			for j in range(len(A1)):
				A2[i] = A2[i]+(A1[j]*brain.C1[j][i])
		for i in range(len(A2)):
			A2[i] = A2[i]+brain.B1[i]
		#
		A3 = [0.0, 0.0]
		for i in range(len(A3)):
			for j in range(len(A2)):
				A3[i] = A3[i]+(A2[j]*brain.C2[j][i])
		for i in range(len(A3)):
			A3[i] = A3[i]+brain.B2[i]
		#
	return A3
	
func reproduce(position_:Vector2, brain_:Dictionary, generation_:int, colorbody_:Color, colorcontour_:Color, gen_counter_visible:bool):
	var id = 0
	if type_==GlobalScript.ID_CONSUMER_1:
		id = 1
	elif type_==GlobalScript.ID_CONSUMER_2:
		id = 2
	var consumer = load("res://Nodes/consumer_%d.tscn" % id).instantiate()
	consumer.position = position_
	consumer.is_offspring = true
	consumer.brain = brain_.duplicate(true)
	consumer.generation = generation_+1
	consumer.get_node('GenCounter').visible = gen_counter_visible
	consumer.get_node('Body').color = Color(colorbody_.r+randf_range(-0.08, 0.08), colorbody_.g+randf_range(-0.08, 0.08), colorbody_.b+randf_range(-0.08, 0.08))
	consumer.get_node('Contour').color = Color(colorcontour_.r+randf_range(-0.08, 0.08), colorcontour_.g+randf_range(-0.08, 0.08), colorcontour_.b+randf_range(-0.08, 0.08))
	consumer.type_ = self.type_
	get_parent().add_child(consumer)

func die():
	self.queue_free()

func _on_mouth_body_entered(body):
	if true: # food<10:
		body.visible = false
		food += 1
		if type_==GlobalScript.ID_CONSUMER_1:
			$TimerLife.start($TimerLife.get_time_left()+GlobalScript.consumer_1_lifetime_increase_after_eating)
		elif type_==GlobalScript.ID_CONSUMER_2:
			$TimerLife.start($TimerLife.get_time_left()+GlobalScript.consumer_2_lifetime_increase_after_eating)
		body.die()

func _on_timer_life_timeout():
	die()

func _on_timer_reproduce_timeout():
	var check:bool
	if type_==1:
		check = get_parent().get_child_count()<get_parent().get_parent().max_consumer1
	elif type_==2:
		check = get_parent().get_child_count()<get_parent().get_parent().max_consumer2
	if food>=food_to_reproduce and check:
		reproduce(position, brain, generation, $Body.color, $Contour.color, $GenCounter.visible)
		food = food-food_to_reproduce

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("click"):
		if (get_node('../../CanvasLayer/VBoxContainer/Misc/show_brain').button_pressed and 
		not get_node('../../CanvasLayer/VBoxContainer/ToggleButtons/add_producer1').button_pressed and
		not get_node('../../CanvasLayer/VBoxContainer/ToggleButtons/add_consumer1').button_pressed and
		not get_node('../../CanvasLayer/VBoxContainer/ToggleButtons/add_consumer2').button_pressed):
			get_node('../../CanvasLayer/Inspector').change_node_to_show_brain(self)
