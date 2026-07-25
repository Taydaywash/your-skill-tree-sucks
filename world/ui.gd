extends CanvasLayer
class_name UI

@export var pause: Panel
@export var animation_player: AnimationPlayer
@export var settings: Panel
@export var negative: AudioStreamWAV
@export var positive: AudioStreamWAV
@export var audio_controller: AudioController

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if settings.visible:
			audio_controller.play_sound(negative,1,1.3)
			settings.visible = false
			return
		audio_controller.play_sound(positive,0.7,0.9)
		pause.visible = !pause.visible
		get_tree().paused = !get_tree().paused

func _on_resume_pressed() -> void:
	audio_controller.play_sound(positive,0.7,0.9)
	pause.visible = false
	get_tree().paused = false

func _on_settings_pressed() -> void:
	audio_controller.play_sound(positive,0.7,0.9)
	settings.visible = true

func _on_quit_pressed() -> void:
	animation_player.play("exit_scene")
	audio_controller.play_sound(negative,1,1.3)
	await animation_player.animation_finished
	pause.visible = false
	get_tree().paused = false
	get_tree().call_deferred("change_scene_to_file","res://title.tscn")

func _on_settings_back_pressed() -> void:
	audio_controller.play_sound(negative,1,1.3)
	settings.visible = false
