extends AudioStreamPlayer2D

onready var die_sound = load("res://sounds/Robot-death.wav")

func die():
	self.stream = die_sound
	self.play()
