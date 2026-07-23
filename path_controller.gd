extends Node2D

@export var node : Button 
@export var required_nodes : Array[Button]

@export var negative : bool
var work_done = false
var faded_in = false

func _process(_delta: float) -> void:
	if work_done:
		return
	if (node.shattered or node.unlocked) and not faded_in:
		work_done = true
		var tween = get_tree().create_tween()
		tween.tween_property(self,"modulate",Color(0,0,0,0),1)
	if faded_in or not negative:
		return
	for required_node in required_nodes:
		if not required_node.unlocked and not required_node.shattered:
			return
	if node.visible == true and not faded_in:
		faded_in = true
		var tween = get_tree().create_tween()
		tween.tween_property(self,"modulate",Color(1,1,1,1),1)
