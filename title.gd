extends Control

@export var audio_controller: AudioController
@export var positive: AudioStreamWAV
@export var negative: AudioStreamWAV


@export var settings_screen: Panel
@export var main: PackedScene

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(main)

func _on_settings_pressed() -> void:
	audio_controller.play_sound(positive,0.7,0.9)
	settings_screen.visible = true

func _on_settings_back_pressed() -> void:
	audio_controller.play_sound(negative,1,1.3)
	settings_screen.visible = false

func _on_quit_pressed() -> void:
	get_tree().quit()
