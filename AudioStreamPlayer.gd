extends AudioStreamPlayer


onready var coffee_take = load("res://assets/sounds/take-coffe-sound.wav") 
onready var game_over_sound = load("res://sounds/Lose.wav")
onready var game_win_sound = load("res://sounds/Win.wav")
onready var lose_life_sound = load("res://sounds/Lose-life.wav")
onready var chrom_explosion_sound = load("res://sounds/Chrome-explosion.wav")
onready var chrom_hit_sound = load("res://sounds/Chorme-hit.wav")
onready var fix_bug = load("res://sounds/Code-grab.wav")
onready var robot_killed_sound = load("res://sounds/Robot-death.wav")

func game_over():
	self.stream = game_over_sound
	self.play()
	
func game_win():
	self.stream = game_win_sound
	self.play()
	
func lose_life():
	self.stream = lose_life_sound
	self.play()
	
func chrom_explosion():
	self.stream = chrom_explosion_sound
	self.play()

func chrom_hit():
	self.stream = chrom_hit_sound
	self.play()

func bug_fixed():
	self.stream = fix_bug
	self.play()
	
func robot_killed():
	self.stream = robot_killed_sound
	self.play()
