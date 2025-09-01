extends Area2D

@export var slowmo_seconds: float = 1.0     # ⏱ ระยะเวลาสโลว์ (วินาทีจริง)
@export var slowmo_scale: float = 0.2       # ⚡ สัดส่วนความช้า (0.2 = ช้าลง 5 เท่า)

var _triggered := false

func _on_body_entered(body: Node2D) -> void:
	if _triggered:
		return
	_triggered = true

	print("[KillZone] You died! slow-mo for ", slowmo_seconds, "s")

	# ⚡ สโลว์ทั้งเกม
	Engine.time_scale = slowmo_scale

	# ❌ ห้ามลบทันทีใน physics callback
	var col := body.get_node_or_null("CollisionShape2D")
	if col:
		col.set_deferred("disabled", true)

	# ปิดการตรวจซ้ำของ killzone
	set_deferred("monitoring", false)

	# ✅ รอ 'เวลาจริง' ตาม slowmo_seconds (ไม่ขึ้นกับ time_scale)
	var end_ms := Time.get_ticks_msec() + int(slowmo_seconds * 1000.0)
	while Time.get_ticks_msec() < end_ms:
		await get_tree().process_frame

	# 🔄 คืนความเร็วปกติ แล้วไปหน้า Game Over
	Engine.time_scale = 1.0
	get_tree().change_scene_to_file("res://scenes/gameOver.tscn")
