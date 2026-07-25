extends Node2D

func spawn_particle(particle_spawn:PackedScene):
	var new_particle = particle_spawn.instantiate()
	new_particle.global_position = global_position
	get_parent().add_sibling(new_particle)
	
