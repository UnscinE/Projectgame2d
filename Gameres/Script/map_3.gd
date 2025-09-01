extends Node2D

@onready var player = $Player
@onready var spawn_point = $SpawnPoint

func _ready():
	player.global_position = spawn_point.global_position

func respawn_player():
	player.global_position = spawn_point.global_position

func update_spawn(new_spawn: Marker2D):
	spawn_point = new_spawn

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
		
