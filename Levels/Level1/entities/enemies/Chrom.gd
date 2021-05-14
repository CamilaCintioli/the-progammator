extends RigidBody2D

var direction = -1
var limit
var over

func _ready():
	add_to_group("chrom")
	limit = get_viewport().size.x

func _physics_process(delta):
	if(! over):
		$AnimationChrom.play("roll")
		position.x += 5 * direction;
		position.x = wrapf(position.x, 0, limit)
	
func _on_Timer_timeout():
	direction *= -1
	
func game_over():
	over = true
	hide()
	
