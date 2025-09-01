# Script/AudioManager.gd
extends Node

@onready var bg         = $AudioStreamPlayer_bg
@onready var walk       = $AudioStreamPlayer_walk
@onready var game_over  = $AudioStreamPlayer_game_over
@onready var jump       = $AudioStreamPlayer_jump

func play_bg():
	if not bg.playing:
		bg.play()

func stop_bg():
	bg.stop()

func play_walk():      walk.play()
func play_game_over(): game_over.play()
func play_jump():      jump.play()
