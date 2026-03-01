extends Control

func _ready():
	var p1_wins = GameState.p1_round_wins
	var p2_wins = GameState.p2_round_wins
	
	if p1_wins > p2_wins:
		$VBoxContainer/WinnerLabel.text = "PLAYER 1 (Prince) WINS!"
		$VBoxContainer/WinnerLabel.add_theme_color_override("font_color", Color(0.2, 1.0, 0.3, 1))
	elif p2_wins > p1_wins:
		$VBoxContainer/WinnerLabel.text = "PLAYER 2 (Narakasur) WINS!"
		$VBoxContainer/WinnerLabel.add_theme_color_override("font_color", Color(1.0, 0.3, 0.2, 1))
	else:
		$VBoxContainer/WinnerLabel.text = "IT'S A DRAW!"
		$VBoxContainer/WinnerLabel.add_theme_color_override("font_color", Color(1, 0.85, 0.2, 1))
	
	$VBoxContainer/ScoreLabel.text = "Prince  " + str(p1_wins) + "  :  " + str(p2_wins) + "  Narakasur"
	$VBoxContainer/RoundDetails.text = "Best of " + str(GameState.max_rounds) + " rounds"
	
	$VBoxContainer/MenuButton.pressed.connect(_on_menu_pressed)
	
	# Dramatic fade-in for all elements
	$VBoxContainer.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property($VBoxContainer, "modulate:a", 1.0, 1.5).set_ease(Tween.EASE_OUT)

func _on_menu_pressed():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.tween_callback(func():
		GameState.reset()
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	)
