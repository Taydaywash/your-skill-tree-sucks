extends Panel

signal skill_hovered

@export var skill_name: Label
@export var skill_description: Label

func _ready() -> void:
	skill_hovered.connect(update_info)

func update_info(name_of_skill: String = "", description : String = ""):
	skill_name.text = name_of_skill
	skill_description.text = description
