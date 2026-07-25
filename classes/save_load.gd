extends Node

const OPTIONS_SAVE_PATH = "user://options.save"
const GAME_STATE_SAVE_PATH = "user://game_state.save"

var options : Dictionary = {
	"screen_size": DisplayServer.WINDOW_MODE_WINDOWED,
	"on_top" : false,
	"master_volume": 1,
	"music_volume": 1,
	"sfx_volume": 1,
	"screen_resolution" : Vector2(1152, 648),
}

var game_state : Dictionary = {
	"cutscene_watched": false,
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

func save_game_state(game_state_copy):
	game_state = game_state_copy.duplicate()
	var file = FileAccess.open(GAME_STATE_SAVE_PATH, FileAccess.WRITE)
	file.store_var(game_state.duplicate())
	file.close()

func load_game_state() -> Dictionary:
	if FileAccess.file_exists(GAME_STATE_SAVE_PATH):
		var file = FileAccess.open(GAME_STATE_SAVE_PATH, FileAccess.READ)
		var data = file.get_var()
		file.close()
		game_state = data.duplicate()
	return game_state.duplicate()

func reset_game_state():
	var file = FileAccess.open(GAME_STATE_SAVE_PATH, FileAccess.WRITE)
	file.store_var(game_state.duplicate())
	file.close()
