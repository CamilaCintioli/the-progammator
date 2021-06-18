extends AudioStreamPlayer


onready var coffee_take = load("res://assets/sounds/take-coffe-sound.wav") 
onready var game_over_sound = load("res://sounds/Lose-life.wav")
onready var game_win_sound = load("res://sounds/Win.wav")

func game_over():
	self.stream = game_over_sound
	self.play()
	
func game_win():
	self.stream = game_win_sound
	self.play()
