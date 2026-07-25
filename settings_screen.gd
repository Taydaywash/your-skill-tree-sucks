extends Panel

@export var audio_controller: AudioController
@export var positive: AudioStreamWAV

func _on_master_scroll_changed(value) -> void:
	AudioServer.set_bus_volume_linear(0,value/100.00)
	audio_controller.play_sound(positive,0.7,1,"Master")
func _on_sfx_scroll_changed(value) -> void:
	AudioServer.set_bus_volume_linear(1,value/100.00)
	audio_controller.play_sound(positive,0.7,1)
func _on_music_scroll_changed(value) -> void:
	AudioServer.set_bus_volume_linear(2,value/100.00)
	audio_controller.play_sound(positive,0.7,1,"Music")
