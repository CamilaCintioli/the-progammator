extends Node

var container
var bugs = 3

func initialize(level_2):
	container = level_2

func _ready():
	add_to_group("code")
	$BugsInfo/Label.text = "bugs: " + str(bugs)
	
func bug():
	bugs -= 1
	get_parent().bug_fixed()
	$BugsInfo/Label.text = "bugs: " + str(bugs)
