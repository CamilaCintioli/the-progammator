extends Control

onready var anim = $bg3Animation
# Called when the node enters the scene tree for the first time.
func _ready():
	#pass # Replace with function body.
	anim.play("matrix-fade")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
