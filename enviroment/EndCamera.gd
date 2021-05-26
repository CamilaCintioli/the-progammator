extends Camera2D

var player

func _ready():
	set_process(false)

func initialize(_programmer):
	player = _programmer

func _process(_delta):
	var playerPositionY = player.global_position.y - 100
	
	if playerPositionY < position.y:
		position = Vector2(position.x, playerPositionY)
