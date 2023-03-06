extends Panel

var grad:Gradient
var node_showing_brain

func _ready():
	grad = Gradient.new()
	grad.add_point(10, Color.BLUE)
	grad.add_point(11, Color.WHITE)
	grad.add_point(12, Color.RED)
	
func update_inspector(A1, A2, A3, C1, C2):
	$VBoxContainer/HBoxContainer/NodeName.text = node_showing_brain.name
	
	for i in range(len(A1)):
		$VBoxContainer/Layers/Input.get_node(str(i+1).pad_zeros(2)).get_node('value').color = grad.sample(A1[i]+11)
	for i in range(len(A2)):
		$VBoxContainer/Layers/Hidden.get_node(str(i+1).pad_zeros(2)).get_node('value').color = grad.sample(A2[i]+11)
	for i in range(len(A3)):
		$VBoxContainer/Layers/Output.get_node(str(i+1).pad_zeros(2)).get_node('value').color = grad.sample(A3[i]+11)
	
	for i in range(len(C1)):
		for j in range(len(C1[i])):
			var n = $C1.get_node('I'+str(j+1)).get_node(str(i+1).pad_zeros(2))
			n.self_modulate = grad.sample(C1[i][j]+11)
			n.width = 8*abs(C1[i][j])

	for i in range(len(C2)):
		for j in range(len(C2[i])):
			var n = $C2.get_node('H'+str(j+1)).get_node(str(i+1).pad_zeros(2))
			n.self_modulate = grad.sample(C2[i][j]+11)
			n.width = 8*abs(C2[i][j])
			
	$Generation.text = 'Generation: %d'% node_showing_brain.generation
	$Lifetime.text = 'Lifetime left: %.02f seconds'%node_showing_brain.get_node('TimerLife').get_time_left()
	$Food.text = 'Food: %d' % node_showing_brain.food

func change_node_to_show_brain(node):
	if node_showing_brain!=null:
		node_showing_brain.showing_brain = false
	node_showing_brain = node
	node_showing_brain.showing_brain = true
