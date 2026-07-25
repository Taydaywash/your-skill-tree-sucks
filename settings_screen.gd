extends Panel

@export var audio_controller: AudioController
@export var positive: AudioStreamWAV
@export var master_scroll: VScrollBar
@export var sfx_scroll: VScrollBar
@export var music_scroll: VScrollBar

func _ready() -> void:
	master_scroll.value = AudioServer.get_bus_volume_linear(0) * 100.00
	sfx_scroll.value = AudioServer.get_bus_volume_linear(1) * 100.00
	music_scroll.value = AudioServer.get_bus_volume_linear(2) * 100.00

func _on_master_scroll_changed(value) -> void:
	AudioServer.set_bus_volume_linear(0,value/100.00)
	audio_controller.play_sound(positive,0.7,1,"Master")
func _on_sfx_scroll_changed(value) -> void:
	AudioServer.set_bus_volume_linear(1,value/100.00)
	audio_controller.play_sound(positive,0.7,1)
func _on_music_scroll_changed(value) -> void:
	AudioServer.set_bus_volume_linear(2,value/100.00)
	audio_controller.play_sound(positive,0.7,1,"Music")
