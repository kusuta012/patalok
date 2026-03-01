extends Control

var pulse_time = 0.0
var title_alpha = 0.0
var subtitle_alpha = 0.0
var button_alpha = 0.0

func _ready():
	$VBoxContainer/PlayButton.pressed.connect(_on_play_pressed)
	
	# Start with everything invisible for fade-in
	$VBoxContainer/TitleLabel.modulate.a = 0.0
	$VBoxContainer/Separator.modulate.a = 0.0
	$VBoxContainer/SubtitleLabel.modulate.a = 0.0
	$VBoxContainer/PlayButton.modulate.a = 0.0
	
	# Staggered fade-in
	var tween = create_tween()
	tween.tween_property($VBoxContainer/TitleLabel, "modulate:a", 1.0, 1.0).set_ease(Tween.EASE_OUT)
	tween.tween_property($VBoxContainer/Separator, "modulate:a", 1.0, 0.5).set_ease(Tween.EASE_OUT)
	tween.tween_property($VBoxContainer/SubtitleLabel, "modulate:a", 1.0, 0.8).set_ease(Tween.EASE_OUT)
	tween.tween_property($VBoxContainer/PlayButton, "modulate:a", 1.0, 0.6).set_ease(Tween.EASE_OUT)

func _process(delta):
	# Pulse the play button gently
	pulse_time += delta * 2.0
	var pulse = 0.85 + 0.15 * sin(pulse_time)
	if $VBoxContainer/PlayButton.modulate.a > 0.5:
		$VBoxContainer/PlayButton.self_modulate = Color(pulse, pulse, pulse, 1.0)

func _on_play_pressed():
	# Fade out before transitioning
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.tween_callback(func(): get_tree().change_scene_to_file("res://scenes/story.tscn"))
