extends Sprite2D

@export var animation_player: AnimationPlayer

func _ready() -> void:
	animation_player.play("flashing")
	await animation_player.animation_finished
	queue_free()
