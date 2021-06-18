extends AudioStreamPlayer


onready var coffee_take = load("res://assets/sounds/take-coffe-sound.wav") 
onready var game_over_sound = load("res://sounds/Lose.wav")
onready var game_win_sound = load("res://sounds/Win.wav")
onready var lose_life = load("res://sounds/Lose-life.wav")
onready var chrom_explosion = load("res://sounds/Chrome-explosion.wav")
onready var chrom_hit = load("res://sounds/Chorme-hit.wav")
onready var fix_bug = load("res://sounds/Code-grab.wav")

func game_over():
	self.stream = game_over_sound
	self.play()
	
func game_win():
	self.stream = game_win_sound
	self.play()
	
func lose_life():
	self.stream = lose_life
	self.play()
	
func chrom_explosion():
	self.stream = chrom_explosion
	self.play()

func chrom_hit():
	self.stream = chrom_hit
	self.play()

func bug_fixed():
	self.stream = fix_bug
	self.play()
