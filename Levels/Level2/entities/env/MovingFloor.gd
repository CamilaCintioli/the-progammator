extends Node

const IDLE_TIME = 1.5

export var speed = 5.0
export var tile_size = 64

onready var platform = $Platform
onready var tween = $Platform/Tween
onready var startPosition = $StartPosition
onready var endPosition = $EndPosition

var follow
var start = false

func _ready():
	follow = $StartPosition.global_position
	
func init_tween():
	var duration = $StartPosition.global_position.length() / float(speed * tile_size)
	tween.interpolate_property(self, "follow", $StartPosition.global_position, $EndPosition.global_position, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, IDLE_TIME)
	tween.interpolate_property(self, "follow", $EndPosition.global_position, $StartPosition.global_position, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + IDLE_TIME * 2)
	tween.start()
	
func _physics_process(_delta):
	platform.global_position = platform.global_position.linear_interpolate(follow, 0.075)

func _on_Cel_body_entered(body):
	if !start and body.is_in_group("dron"):
		init_tween()
		$Cel/On.visible = true
		$Cel/Off.visible = false
		start = true
