extends Area2D

onready var animcooler = $sawCoolerAnim
# Called when the node enters the scene tree for the first time.
func _ready():
	animcooler.play("spin-saw-cooler")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
