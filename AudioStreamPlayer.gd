extends AudioStreamPlayer


onready var game_over_sound = load("res://assets/sounds/windows.ogg")
onready var game_win_sound = load("res://sounds/Win.wav")
onready var lose_life_sound = load("res://sounds/Lose-life.wav")
onready var chrom_explosion_sound = load("res://sounds/Chrome-explosion.wav")
onready var chrom_hit_sound = load("res://sounds/Chorme-hit.wav")
onready var fix_bug = load("res://sounds/Code-grab.wav")
onready var robot_killed_sound = load("res://sounds/Robot-death.wav")
onready var take_coffee = load("res://assets/sounds/take-coffe-sound.wav")
onready var cel_audio_sound = load("res://sounds/celAudio.wav")
onready var jump_sound = load("res://sounds/jumping.ogg")

func jump():
	self.stream = jump_sound
	self.set_volume_db(-0.90)
	
	self.play()

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

func take_coffee_sound():
	self.stream = take_coffee
	self.play()
	
func cel_audio():
	self.stream = cel_audio_sound
	self.play()
