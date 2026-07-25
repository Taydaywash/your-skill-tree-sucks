extends AnimatedSprite2D

@export_category("General")
@export var player: Player
@export var animation_player: AnimationPlayer

#Melee
var current_melee = "spear"

@export_category("Spear")
@export var spear_chargeup_time : float = 0.5
@export var spear_raycast: RayCast2D
var spear_charged : bool = false
var spear_chargeup_cancelled : bool = false
var spear_chargeup : Timer

#Range
var current_range = "harpoon"
@export var harpoon_shot: PackedScene
@export var harpoon_cooldown_time: float
var harpoon_cooldown : Timer

@export_category("Gun")
@export var gun_shot: PackedScene
@export var gun_cooldown_time: float
var gun_cooldown: Timer

func _ready() -> void:
	spear_chargeup = Timer.new()
	spear_chargeup.wait_time = spear_chargeup_time
	spear_chargeup.autostart = false
	spear_chargeup.one_shot = true
	add_child(spear_chargeup)

	harpoon_cooldown = Timer.new()
	harpoon_cooldown.wait_time = harpoon_cooldown_time
	harpoon_cooldown.autostart = false
	harpoon_cooldown.one_shot = true
	add_child(harpoon_cooldown)
	
	gun_cooldown = Timer.new()
	gun_cooldown.wait_time = gun_cooldown_time
	gun_cooldown.autostart = false
	gun_cooldown.one_shot = true
	add_child(gun_cooldown)
	
	EventController.connect("unlock_sword",func ():
		current_melee = "sword"
		play("sword_idle")
	)
	EventController.connect("unlock_fist",func ():
		current_melee = "fist"
		play("fist_idle")
	)
	EventController.connect("unlock_gun",func ():
		current_range = "gun"
		play("gun_idle")
	)
	EventController.connect("unlock_rock_throw",func ():
		current_range = "rock"
		play("fist_idle")
	)
	
func _process(_delta: float) -> void:
	if spear_raycast.is_colliding() and not player.movement_disabled:
		player.movement_disabled = true
		player.velocity = (player.position - spear_raycast.get_collision_point()).normalized() * 1000
		#spear_raycast.enabled = false
		await get_tree().create_timer(0.1).timeout
		player.movement_disabled = false
	if animation_player.is_playing() and (animation_player.current_animation == "spear_attack" or animation_player.current_animation == "sword_attack"):
		return
	position = (get_global_mouse_position() - get_parent().global_position).normalized() * 20
	match current_melee:
		"spear":
			look_at(get_parent().global_position)
			rotate(PI)
		"fist":
			look_at(get_parent().global_position)
			rotate(PI)
		"sword":
			look_at(get_parent().global_position)
			rotate(PI)

func _input(event: InputEvent) -> void:
	if player.player_disabled:
		return
	
	if event.is_action_pressed("melee_attack"):
		match current_melee:
			"spear":
				spear_chargeup.start()
				await spear_chargeup.timeout
				animation_player.play("spear_attack")
			"sword":
				animation_player.play("sword_attack")
			"fist":
				play("fist_idle")

	if event.is_action_pressed("range_attack"):
		match current_range:
			"harpoon":
				if harpoon_cooldown.time_left:
					return
				harpoon_cooldown.start()
				play("harpoon_idle")
				var harpoon_shot_instance = harpoon_shot.instantiate()
				get_parent().add_sibling(harpoon_shot_instance)
				harpoon_shot_instance.global_position = get_parent().global_position
				harpoon_shot_instance.velocity = (global_position - harpoon_shot_instance.global_position).normalized() * harpoon_shot_instance.speed
				harpoon_shot_instance.hand = self
			"gun":
				play("gun_idle")
				var gun_shot_instance = gun_shot.instantiate()
				get_parent().add_sibling(gun_shot_instance)
				gun_shot_instance.global_position = get_parent().global_position
				gun_shot_instance.velocity = (global_position - gun_shot_instance.global_position).normalized() * gun_shot_instance.speed
				gun_shot_instance.hand = self
			"rock":
				play("fist_idle")
		if animation_player.is_playing():
			await animation_player.animation_finished
		animation_player.play("range_attack")
	
