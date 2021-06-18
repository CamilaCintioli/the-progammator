extends AudioStreamPlayer2D


onready var jump = load("res://sounds/Jump.wav")

func jump():
	self.stream = jump
	self.play()
