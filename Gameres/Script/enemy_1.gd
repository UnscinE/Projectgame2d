extends Node2D

@export var speed: float = 60.0
@export var start_facing_right := true
@export var flip_sprite := true
@export var turn_cooldown := 0.12

@onready var rc_right: RayCast2D = $RayCastRight
@onready var rc_left:  RayCast2D = $RayCastLeft
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var dir := 1
var turn_lock := 0.0

func _ready() -> void:
	dir = 1 if start_facing_right else -1
	if sprite and flip_sprite:
		sprite.flip_h = (dir == -1) # หันซ้ายเมื่อ dir = -1
	if sprite and sprite.has_method("play"):
		sprite.play()

func _process(delta: float) -> void:
	if turn_lock > 0.0:
		turn_lock -= delta

	var hit_r := rc_right and rc_right.is_colliding()
	var hit_l := rc_left  and rc_left.is_colliding()

	# เดินไปขวา แล้วชนขวา → กลับซ้าย
	if dir == 1 and hit_r and turn_lock <= 0.0:
		dir = -1
		turn_lock = turn_cooldown
		if sprite and flip_sprite:
			sprite.flip_h = true  # หันซ้าย
		# ถอยออกนิดหน่อยกันค้าง (optional)
		position.x -= 1.0

	# เดินไปซ้าย แล้วชนซ้าย → กลับขวา
	elif dir == -1 and hit_l and turn_lock <= 0.0:
		dir = 1
		turn_lock = turn_cooldown
		if sprite and flip_sprite:
			sprite.flip_h = false # หันขวา
		# ถอยออกนิดหน่อยกันค้าง (optional)
		position.x += 1.0

	# เดิน
	position.x += dir * speed * delta


func _on_killzone_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
