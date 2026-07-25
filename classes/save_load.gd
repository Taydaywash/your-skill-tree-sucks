extends Node

const OPTIONS_SAVE_PATH = "user://options.save"

var options : Dictionary = {
	"screen_size": DisplayServer.WINDOW_MODE_WINDOWED,
	"on_top" : false,
	"master_volume": 1,
	"music_volume": 1,
	"sfx_volume": 1,
	"screen_resolution" : Vector2(1152, 648),
}

func save_options(options_copy):
	options = options_copy.duplicate()
	var file = FileAccess.open(OPTIONS_SAVE_PATH, FileAccess.WRITE)
	file.store_var(options.duplicate())
	file.close()

func load_options() -> Dictionary:
	if FileAccess.file_exists(OPTIONS_SAVE_PATH):
		var file = FileAccess.open(OPTIONS_SAVE_PATH, FileAccess.READ)
		var data = file.get_var()
		file.close()
		options = data.duplicate()
	return options.duplicate()
