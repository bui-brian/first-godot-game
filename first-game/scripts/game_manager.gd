extends Node

@onready var score_label: Label = $ScoreLabel
@onready var you_win: Label = $YouWin

var score: int = 0
var flag_triggered: bool = false

func add_point():
	score += 1
	score_label.text = "You collected " + str(score) + " coins"

func _player_wins():
	flag_triggered = true
	you_win.visible = true
