extends CanvasLayer

export var _heartNum = 5
export var _chromLives = 5
export var _bosslives = 1
onready var sprite = $Wifi/wifisignal
var level

onready var fade_tween = $Fade/Tween
onready var fade = $Fade/BlackScreen
onready var wifi = $Wifi

var heartNum = 0
var chromLives = 0
var bosslives = 0

var finGame = false
	
func _ready():
	$grayRect.hide()
	$blackRect.hide()
	$redRect.hide()
	$GameOver.hide()
	$RestartButton.hide()
	$WinButton.hide()
	$TopBar.hide()
	wifi.show()
	fade.color.a = 0
	fade.hide()
	
	finGame = false
	
func initialize(theLevel):
	level = theLevel
	$grayRect/heartsNumber.text = str(_heartNum)
	$grayRect.show()
	wifi.show()
	#$TopBar.show()
	#$TopBar/connection.text = "offline"
	set_on()
	
func fade_to_black():
	fade.show()
	fade_tween.interpolate_property(fade, "color", fade.color, Color.black, 1)
	fade_tween.start()
	
func set_chrome_bar():
	chromLives = _chromLives
	$blackRect/livesNumber.text = str(_chromLives)
	$blackRect.show()

func hide_chrome_bar():
	$blackRect.hide()
	
func livesDecrease(audio_stream):
	if !finGame and heartNum != 0:
		heartNum -= 1
		audio_stream.lose_life()
		$grayRect/heartsNumber.text = str(heartNum)
		if heartNum <= 0:
			game_over(audio_stream)

func livesIncrease():
		heartNum += 1
		$grayRect/heartsNumber.text = str(heartNum)
	
func show_message():
	$GameOver.show()
	$GameOverTimer.start()
	
func set_on():
	heartNum = _heartNum
	$grayRect/heartsNumber.text = str(heartNum)
	$grayRect/greenHeart.set_modulate(Color.green)
	wifi.show()
	
	
func game_over(audio_stream):
	if !finGame:
		fade_to_black()
		level.game_over()
		audio_stream.game_over()
		$grayRect/greenHeart.set_modulate(Color.darkgreen)
		show_message()
		yield($GameOverTimer, "timeout")
		$RestartButton.show()
		
func _on_RestartButton_pressed():
	$RestartButton.hide()
	$WinButton.hide()
	level.restart_tree()

func _on_GameOverTimer_timeout():
	$GameOver.hide()
	$GameOverTimer.stop()
	
func you_win():
	get_tree().change_scene("res://final/Final.tscn")
#	$WinButton.show()
	
func chrom_hit():
	if chromLives != 0:
		chromLives -= 1
		$blackRect/livesNumber.text = str(chromLives)
		if chromLives <= 0:
			level.chrom_finished()
			
func set_end_enemy_bar():
	$redRect.show()
	bosslives = _bosslives
	$redRect/livesNumber.text = str(bosslives)
#	set_on()
	
func end_enemy_hit():
	if chromLives != 0:
		chromLives -= 1
		$blackRect/livesNumber.text = str(chromLives)
		if chromLives <= 0:
			finGame = true
			
func endEnemy_hit():
	if bosslives != 0:
		bosslives -= 1
		$redRect/livesNumber.text = str(bosslives)
		if bosslives <= 0:
			finGame = true

func _on_WinButton_pressed():
	get_tree().change_scene("res://Game.tscn")
	
func set_dron_connection(conn_level):
	
	sprite.frame = conn_level
	if (conn_level == 0 ):
		$DisconnectedBar.show()
		$DisconnectedBar/Disconnected.text = "Wifi signal lost"
		$DisconnectedTimer.start()
		
func display_connection(_player_pos):
	pass
	#wifi.rect_position = _player_pos
	
func start_dron_connection():
	wifi.show()
	
func stop_dron_connection():
	pass
	
func _on_DisconnectedTimer_timeout():
	level.change_control()
	$DisconnectedBar.hide()
	$DisconnectedBar/Disconnected.text = ""
