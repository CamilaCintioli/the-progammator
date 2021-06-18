extends AudioStreamPlayer


onready var coffee_take = load("res://assets/sounds/take-coffe-sound.wav") 
onready var game_over = load("res://sounds/Lose.wav")
onready var game_win = load("res://sounds/Win.wav")
onready var lose_life = load("res://sounds/Lose-life.wav")
onready var chrom_explosion = load("res://sounds/Chrome-explosion.wav")

func game_over():
	self.stream = game_over
	self.play()
	
func game_win():
	self.stream = game_win
	self.play()
	
func lose_life():
	self.stream = lose_life
	self.play()
	
func chrom_explosion():
	self.stream = chrom_explosion
	self.play()
