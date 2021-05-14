extends CanvasLayer

var heartNum = 0
var level
	
func _ready():
	$grayRect.hide()
	$GameOver.hide()
	$RestartButton.hide()
	
func initialize(theLevel):
	level = theLevel
	heartNum = 3
	$grayRect/heartsNumber.text = str(heartNum)
	$grayRect.show()
	
func livesDecrease():
	heartNum -= 1
	$grayRect/heartsNumber.text = str(heartNum)
	if heartNum <= 0:
		$grayRect/heartsNumber.text = str(heartNum)
		game_over()

func show_message():
	$GameOver.show()
	$GameOverTimer.start()
	
func game_over():
	$grayRect/heart.set_modulate(Color.darkgreen)
	show_message()
	yield($GameOverTimer, "timeout")
	$RestartButton.show()
	
	level.game_over()

func _on_RestartButton_pressed():
	$RestartButton.hide()
	level.restart()

func _on_GameOverTimer_timeout():
	$GameOver.hide()
	$GameOverTimer.stop()
	
