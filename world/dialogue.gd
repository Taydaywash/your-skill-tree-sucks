extends Panel
@export var speaker: Label
@export var dialogue_text: Label
@export var dialogue_box: AnimationPlayer

signal next_dialogue
signal dialogue_finished
@export var audio_controller: AudioController

@export var creator_speak: AudioStreamWAV
@export var player_speak: AudioStreamWAV
@export var continue_carat: Label
@export var time_between_letters : float = 0.05

@export var dev_talk: AudioStreamWAV

func type_text(dialogue : Array):
	for box in dialogue:
		continue_carat.visible = false
		speaker.text = box.speaker
		dialogue_text.text = box.text
		dialogue_text.visible_characters = 0
		dialogue_box.play("show")
		await dialogue_box.animation_finished
		for i in range(0,dialogue_text.get_total_character_count()):
			dialogue_text.visible_characters += 1
			match speaker.text:
				"Player":
					audio_controller.play_sound(player_speak,0.5,0.5)
				"Creator":
					audio_controller.play_sound(creator_speak,1,1)
				"Devs":
					audio_controller.play_sound(dev_talk,1,1)
			if dialogue_text.text[i] == "?" or dialogue_text.text[i] == "." or dialogue_text.text[i] == "!":
				await get_tree().create_timer(0.2).timeout
			if dialogue_text.text[i] == "-":
				await get_tree().create_timer(0.1).timeout
			await get_tree().create_timer(time_between_letters).timeout
		continue_carat.visible = true
		await next_dialogue
	dialogue_box.play("hide")
	await dialogue_box.animation_finished
	dialogue_finished.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("melee_attack"):
		next_dialogue.emit()
