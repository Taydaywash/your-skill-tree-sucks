extends Node2D
@export var animation_player: AnimationPlayer
@export var cut_scene_animator: AnimationPlayer
@export var dialogue: Panel
@export var spawner: Node2D
@export var music: AudioStreamPlayer2D
@export var player: Player

@export var audio_controller: AudioController
@export var creator_speak: AudioStreamWAV

#Scene 1
const s1b1 : Dictionary = {
	"speaker":"Player",
	"text":"Wh- why can't I move!? What's going on? ...It was that upgrade wasn't it. The 'Lamenting Chains of Order and Chaos.' What a dumb name... Every 'upgrade' I've gotten has only made things worse. This skill tree sucks!"
}
const s1b2 : Dictionary = {
	"speaker":"Creator",
	"text":"You... don't like my skill tree? :("
}
const s1b3 : Dictionary = {
	"speaker":"Player",
	"text":"NO! Your skill tree is terrible! I'd rather have no skills at all."
}
const s1b4 : Dictionary = {
	"speaker":"Creator",
	"text":"We- well fine then! Let's see how you like it when you start leveling DOWN instead of UP!"
}
const s1 = [s1b1,s1b2,s1b3,s1b4]

func _ready() -> void:
	#SaveLoad.reset_game_state()
	var game_state = SaveLoad.load_game_state()
	for orb in cut_scene_animator.get_children():
		orb.global_position = Vector2(9999,9999)
	await get_tree().create_timer(1).timeout
	if not game_state.cutscene_watched:
		await get_tree().create_timer(2).timeout
		player.player_disabled = true
		cut_scene_animator.play("1")
		await cut_scene_animator.animation_finished
		dialogue.type_text(s1)
		await dialogue.dialogue_finished
		cut_scene_animator.play("2")
		await cut_scene_animator.animation_finished
		player.player_disabled = false
		SaveLoad.save_game_state({
			"cutscene_watched": true,
		})
	for orb in cut_scene_animator.get_children():
		orb.visible=true
		orb.global_position = orb.starting_position
		audio_controller.play_sound(creator_speak)
		await get_tree().create_timer(0.2).timeout
	spawner.is_spawning = true
	#music.playing = true
