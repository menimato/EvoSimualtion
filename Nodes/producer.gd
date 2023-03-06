extends RigidBody2D

var type_ = 0
var new_position = Vector2(0, 0)
var should_reset = false

func _ready():
	$Timer.timeout.connect(reproduce)
	$Timer.set_wait_time(randf_range(GlobalScript.producer_1_min_TimerReproduce, GlobalScript.producer_1_max_TimerReproduce))
	$Timer.start()

func _integrate_forces(state):
	if should_reset:
		state.transform.origin = new_position
		should_reset = false

func _process(_delta):
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

func reproduce():
	if get_parent().get_child_count()<get_parent().get_parent().max_creator1:
		var creator_1 = load("res://Nodes/producer_1.tscn").instantiate()
		creator_1.position = self.position+Vector2(randi_range(-1, 1), randi_range(-1, 1))
		get_parent().add_child(creator_1)

func die():
	self.queue_free()
