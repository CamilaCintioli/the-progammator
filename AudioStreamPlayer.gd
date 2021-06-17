extends AudioStreamPlayer


onready var coffee_take = load("res://assets/sounds/take-coffe-sound.wav") 
onready var game_over = load("res://sounds/Lose.wav")

func game_over():
	self.stream = game_over
	self.play()
