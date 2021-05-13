extends Node

var container
var codes = []

func initialize(level_2):
	container = level_2

func _ready():
	add_to_group("code")

func _on_For_body_entered(body):
	if body.is_in_group("programmer"):
		codes.append('for')
		$For.hide()
		$CodesInfo/Label.text = "codes: " + str(codes)

func _on_While_body_entered(body):
	if body.is_in_group("programmer"):
		codes.append('while')
		$While.hide()
		$CodesInfo/Label.text = "codes: " + str(codes)

func _on_If_body_entered(body):
	if body.is_in_group("programmer"):
		codes.append('if')
		$If.hide()
		$CodesInfo/Label.text = "codes: " + str(codes)
