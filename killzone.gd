extends Area2D

# --------- SETTINGS ---------- #
@export_enum("ReloadScene", "RespawnAtSpawn") var respawn_mode: String = "ReloadScene"

# --------- FUNCTIONS ---------- #
func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		
		return
#
	#print("[KillZone] Player died! Mode:", respawn_mode)
#
	#match respawn_mode:
		#"ReloadScene":
			## รีสตาร์ททั้งด่าน
			#get_tree().reload_current_scene()
#
		#"RespawnAtSpawn":
			## ถ้า Player มี spawn_point -> ย้ายไปที่จุดนั้น
			#if body.has_node("%SpawnPoint"):
				#var spawn = body.get_node("%SpawnPoint")
				#body.global_position = spawn.global_position
				#body.velocity = Vector2.ZERO
			#else:
				#push_warning("Player has no %SpawnPoint! Reloading scene instead.")
				#get_tree().reload_current_scene()
