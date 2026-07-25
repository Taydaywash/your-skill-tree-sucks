extends CharacterBody2D

@export var speed: int = 750
@export var shrapnel_shot: Sprite2D

func _ready() -> void:
	$Timer.start()

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _on_damage_area_area_entered(area):
	if area.get_collision_layer_value(3):
		call_deferred("queue_free")

func _on_damage_area_body_entered(body):
	if $Timer.is_stopped():
		if body.get_collision_layer_value(1):
			call_deferred("queue_free")
