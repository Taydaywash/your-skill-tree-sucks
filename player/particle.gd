extends CPUParticles2D
class_name particle

func _ready() -> void:
	look_at(get_global_mouse_position())
	await get_tree().process_frame
	emitting = true
	await finished
	queue_free()
