extends Panel

@export var audio_controller: AudioController
@export var positive: AudioStreamWAV
@export var master_scroll: VScrollBar
@export var sfx_scroll: VScrollBar
@export var music_scroll: VScrollBar

var options : Dictionary = {
	"screen_size": DisplayServer.WINDOW_MODE_WINDOWED,
	"on_top" : false,
	"master_volume": 1,
	"music_volume": 1,
	"sfx_volume": 1,
	"screen_resolution" : Vector2(1152, 648),
}

func _ready() -> void:
	options = SaveLoad.load_options()
	AudioServer.set_bus_volume_linear(0,options.master_volume)
	AudioServer.set_bus_volume_linear(1,options.music_volume)
	AudioServer.set_bus_volume_linear(2,options.sfx_volume)
	DisplayServer.window_set_size(options.screen_resolution)
	DisplayServer.window_set_mode(options.screen_size)
	master_scroll.value = AudioServer.get_bus_volume_linear(0) * 100.00
	sfx_scroll.value = AudioServer.get_bus_volume_linear(1) * 100.00
	music_scroll.value = AudioServer.get_bus_volume_linear(2) * 100.00

func _on_master_scroll_changed(value) -> void:
	AudioServer.set_bus_volume_linear(0,value/100.00)
	audio_controller.play_sound(positive,0.7,1,"Master")
	SaveLoad.save_options(format_options())
func _on_sfx_scroll_changed(value) -> void:
	AudioServer.set_bus_volume_linear(1,value/100.00)
	audio_controller.play_sound(positive,0.7,1)
	SaveLoad.save_options(format_options())
func _on_music_scroll_changed(value) -> void:
	AudioServer.set_bus_volume_linear(2,value/100.00)
	audio_controller.play_sound(positive,0.7,1,"Music")
	SaveLoad.save_options(format_options())

#0 1156 x 648
#1 1280 x 720
#2 1920 x 1080
func _on_screen_resolution_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2(1156,648))
		1:
			DisplayServer.window_set_size(Vector2(1280,720))
		2:
			DisplayServer.window_set_size(Vector2(1920,1080))
	SaveLoad.save_options(format_options())

#0 Windowed
#1 Fullscreen
func _on_screen_mode_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	SaveLoad.save_options(format_options())
	apply_options()

func apply_options():
	AudioServer.set_bus_volume_linear(0,options.master_volume)
	AudioServer.set_bus_volume_linear(1,options.music_volume)
	AudioServer.set_bus_volume_linear(2,options.sfx_volume)
	DisplayServer.window_set_size(options.screen_resolution)
	DisplayServer.window_set_mode(options.screen_size)
	master_scroll.value = AudioServer.get_bus_volume_linear(0) * 100.00
	sfx_scroll.value = AudioServer.get_bus_volume_linear(1) * 100.00
	music_scroll.value = AudioServer.get_bus_volume_linear(2) * 100.00

func format_options():
	var fomratted_options : Dictionary = {
	"screen_size": DisplayServer.window_get_mode(0),
	"on_top" : false,
	"master_volume": AudioServer.get_bus_volume_linear(0),
	"music_volume": AudioServer.get_bus_volume_linear(1),
	"sfx_volume": AudioServer.get_bus_volume_linear(2),
	"screen_resolution" : Vector2(1152, 648),
	}
	options = fomratted_options
	return fomratted_options
