extends AudioStreamPlayer


onready var coffee_take = load("res://assets/sounds/take-coffe-sound.wav") 
onready var game_over = load("res://sounds/Lose.wav")
onready var game_win = load("res://sounds/Win.wav")

func game_over():
	self.stream = game_over
	self.play()
	
func game_win():
	self.stream = game_win
	self.play()
