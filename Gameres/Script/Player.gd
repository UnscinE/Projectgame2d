extends CharacterBody2D

# --------- VARIABLES ---------- #

@export_category("Player Properties") # You can tweak these changes according to your likings
@export var move_speed : float = 2400
@export var jump_force : float = 1600
@export var gravity : float = 25
@export var max_jump_count : int = 20
var jump_count : int = 2


@export_category("Toggle Functions") # Double jump feature is disable by default (Can be toggled from inspector)
@export var double_jump : = true

var is_grounded : bool = false

@onready var player_sprite = $AnimatedSprite2D
@onready var particle_trails = $ParticleTrails
@onready var death_particles = $DeathParticles
@onready var hp: int = 3
@onready var hp_label: Label = $Label  # get the label node

# --------- BUILT-IN FUNCTIONS ---------- #
func _ready() -> void:
	_update_hp_label()

func _process(_delta):
	# Calling functions
	movement()
	player_animations()
	flip_player()
	print("Current Scale: ", self.scale)
	
# --------- CUSTOM FUNCTIONS ---------- #

# <-- Player Movement Code -->
func movement():
	# Gravity
	if !is_on_floor():
		velocity.y += gravity
	elif is_on_floor():
		jump_count = max_jump_count
	
	handle_jumping()
	
	# Move Player
	var inputAxis = Input.get_axis("Left", "Right")
	velocity = Vector2(inputAxis * move_speed, velocity.y)
	move_and_slide()

# Handles jumping functionality (double jump or single jump, can be toggled from inspector)
func handle_jumping():
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor() and !double_jump:
			jump()
		elif double_jump and jump_count > 0:
			jump()
			jump_count -= 1

# Player jump
func jump():
	velocity.y = -jump_force

# Handle Player Animations
func player_animations():
	
	if is_on_floor():
		if abs(velocity.x) > 0:
			player_sprite.play("Walk", 1.5)
		else:
			player_sprite.play("Idle")
	else:
		player_sprite.play("Jump")

# Flip player sprite based on X velocity
func flip_player():
	if velocity.x < 0: 
		player_sprite.flip_h = true
	elif velocity.x > 0:
		player_sprite.flip_h = false


# --------- SIGNALS ---------- #

# Reset the player's position to the current level spawn point if collided with any trap
func _on_collision_body_entered(_body):
	if _body.is_in_group("Lava"):
		death_particles.emitting = true


func _on_collision_area_entered(area: Area2D) -> void: #Working code ///
	if area.is_in_group("Lava"):
		hp -= 1
		_update_hp_label()
		_check_death_or_respawn()

	elif area.is_in_group("Mob"):
		hp -= 1
		_update_hp_label()
		_check_death_or_respawn()

	if area.is_in_group("Door"):
		get_tree().change_scene_to_file("res://Gameres/Scene/menu.tscn")
		
	if area.is_in_group("Door_map1"):
		call_deferred("_change_scene", "res://Gameres/Scene/map_2.tscn")

	if area.is_in_group("Door_map2"):
		call_deferred("_change_scene", "res://Gameres/Scene/map_3.tscn")

	if area.is_in_group("Checkpoint"):
		var cp_marker = area.get_parent() as Marker2D
		if cp_marker:
			get_parent().update_spawn(cp_marker)
		
	if area.is_in_group("Checkpoint"):
		#get_tree().quit()
		var cp_marker = area.get_parent() as Marker2D
		if cp_marker:
			get_parent().update_spawn(cp_marker)
			
func _check_death_or_respawn() -> void:
	if hp == 0:
		get_tree().change_scene_to_file("res://Gameres/Scene/gameoverscene.tscn")
	else:
		get_parent().respawn_player()
		death_particles.emitting = false

func _update_hp_label() -> void:
	hp_label.text = "HP: %d" % hp

func _change_scene(path: String) -> void:
	get_tree().change_scene_to_file(path)
