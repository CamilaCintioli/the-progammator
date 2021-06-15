extends CanvasLayer

export var heartNum = 0
export var chromLives = 0

export var bosslives = 0
var level
	
func _ready():
	$grayRect.hide()
	$blackRect.hide()
	$redRect.hide()
	$GameOver.hide()
	$RestartButton.hide()
	$WinButton.hide()
	
func initialize(theLevel):
	level = theLevel
	$grayRect/heartsNumber.text = str(heartNum)
	$grayRect.show()
	
func set_chrome_bar():
	$blackRect/livesNumber.text = str(heartNum)
	$blackRect.show()

func hide_chrome_bar():
	$blackRect.hide()
	
func livesDecrease():
	if(heartNum!=0):
		heartNum -= 1
		$grayRect/heartsNumber.text = str(heartNum)
		if heartNum <= 0:
			game_over()


func livesIncrease():
		heartNum += 1
		$grayRect/heartsNumber.text = str(heartNum)
	
func show_message():
	$GameOver.show()
	$GameOverTimer.start()
	
func set_on():
	heartNum = 3
	$grayRect/heartsNumber.text = str(heartNum)
	$grayRect/greenHeart.set_modulate(Color.green)
	
	
func game_over():
	$grayRect/greenHeart.set_modulate(Color.darkgreen)
	show_message()
	yield($GameOverTimer, "timeout")
	$RestartButton.show()
	level.game_over()

func _on_RestartButton_pressed():
	$RestartButton.hide()
	$WinButton.hide()
	level.restart_tree()

func _on_GameOverTimer_timeout():
	$GameOver.hide()
	$GameOverTimer.stop()
	
func you_win():
	$WinButton.show()
	
func chrom_hit():
	if(chromLives!=0):
		chromLives -= 1
		$blackRect/livesNumber.text = str(chromLives)
		if chromLives <= 0:
			level.chrom_finished()
			
func set_end_enemy_bar():
	$redRect.show()
	bosslives = 3
	$redRect/livesNumber.text = str(bosslives)
#	set_on()
	
func end_enemy_hit():
	if(chromLives!=0):
		chromLives -= 1
		$blackRect/livesNumber.text = str(chromLives)
		if chromLives <= 0:
			level.pc_finished()
			you_win()
			
func endEnemy_hit():
	if(bosslives!=0):
		bosslives -= 1
		$redRect/livesNumber.text = str(bosslives)
		if bosslives <= 0:
			level.pc_finished()
			you_win()

func _on_WinButton_pressed():
	get_tree().change_scene("res://Game.tscn")
