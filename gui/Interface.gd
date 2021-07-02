extends CanvasLayer

export var _heartNum = 5
export var _chromLives = 5
export var _bosslives = 1
var level

onready var fade_tween = $Fade/Tween
onready var fade = $Fade/BlackScreen
onready var wifi = $Wifi
onready var sprite = $Wifi/wifisignal

var colorWifi = {0: Color.red, 1:Color.orange, 2:Color.green, 3:Color.blue}
var heartNum = 0
var chromLives = 0
var bosslives = 0

var new_style = StyleBoxFlat.new()

var finGame = false
	
func _ready():
	$grayRect.hide()
	$blackRect.hide()
	$redRect.hide()
	$GameOver.hide()
	$RestartButton.hide()
	$WinButton.hide()
	$TopBar.hide()
	fade.color.a = 0
	fade.hide()
	
	finGame = false
	
func initialize(theLevel):
	level = theLevel
	$grayRect/heartsNumber.text = str(_heartNum)
	$grayRect.show()
	set_on()
	init_override_style(new_style)

	
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
	#wifi.show()
	
func game_over(audio_stream):
	if !finGame:
		$grayRect/heartsNumber.text = str(0)
		fade_to_black()
		level.game_over()
		audio_stream.game_over()
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
	new_style.set_border_color(colorWifi[conn_level])
	wifi.set('custom_styles/panel', new_style)
	if (conn_level == 0 ):
		$DisconnectedBar.show()
		$DisconnectedBar/Disconnected.text = "Wifi signal lost"
		$DisconnectedTimer.start()
		

	
func start_dron_connection():
	wifi.show()
	
func show_dron_connection(can_show):
	if(can_show):
		wifi.show()
	else:
		wifi.hide()
	
func _on_DisconnectedTimer_timeout():
	level.change_control()
	$DisconnectedBar.hide()
	$DisconnectedBar/Disconnected.text = ""

func init_override_style(style):
	style.set_bg_color(Color( 0, 0, 0, 0.717647 ))
	style.set_border_width_all(5)
	style.set_border_color(Color( 0.243137, 0.223529, 0.223529, 1 ))
	style.set_corner_radius_all(15)
	style.set_border_blend(true)
