extends Node2D

@export var health_bar: ProgressBar
@export var xp_bar: ProgressBar
@export var level_counter: Label
@export var skill_point_counter: Label
@export var player: Player = null
@export var continue_button: Button

@export var level_down_animator: AnimationPlayer
@export var level_down_text: Sprite2D
@export var projectile_killer: Area2D


var current_skill_points: int = -0

func _ready() -> void:
	EventController.level_down.connect(level_down)
	set_skill_points_label()

func _input(_event: InputEvent) -> void:
	pass

func level_down() -> void:
	player.velocity = Vector2.ZERO
	player.player_disabled = true
	player.movement_disabled = true
	projectile_killer.position = Vector2.ZERO
	level_down_text.global_position = player.global_position + Vector2(-88,-49.72)
	level_down_animator.play("Level Down")
	await level_down_animator.animation_finished
	toggle_visibility()
	current_skill_points -= 1
	set_skill_points_label()
	
func toggle_visibility() -> void:
	visible = !visible
	health_bar.visible = !visible
	xp_bar.visible = !visible
	level_counter.visible = !visible

func set_skill_points_label() -> void:
	if current_skill_points < 0:
		continue_button.disabled = true
	else:
		continue_button.disabled = false
	skill_point_counter.text = "Skill Points: %d" % [current_skill_points]

func unpause() -> void:
	toggle_visibility()
	EventController.unpause_enemies.emit()
	projectile_killer.position = Vector2(0,1100)
	player.player_disabled = false
	player.movement_disabled = false

func _on_continue_button_pressed():
	unpause()
