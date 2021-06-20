extends AudioStreamPlayer2D

onready var jump_sound = load("res://sounds/Jump.wav")

func jump():
	self.stream = jump_sound
	self.play()
