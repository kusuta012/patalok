extends Control

var story_lines = [
	"In the ancient realm of Paatalok, beneath the earth...",
	"The Demon King Narakasur has risen to challenge the Prince.",
	"Only through combat can balance be restored.",
	"3 rounds. Last one standing wins.",
	"Let the battle begin!"
]

var current_line = 0
var can_advance = false

func _ready():
	$StoryLabel.modulate.a = 0.0
	show_line()

func show_line():
	if current_line >= story_lines.size():
		return
	can_advance = false
	$StoryLabel.text = story_lines[current_line]
	$ProgressLabel.text = str(current_line + 1) + " / " + str(story_lines.size())
	$ContinueLabel.text = "Press ENTER to continue..."
	
	# Fade in the text
	var tween = create_tween()
	tween.tween_property($StoryLabel, "modulate:a", 1.0, 0.6).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func(): can_advance = true)

func _input(event):
	if event.is_action_pressed("ui_accept") and can_advance:
		current_line += 1
		if current_line >= story_lines.size():
			# Fade out entire scene before transitioning
			var tween = create_tween()
			tween.tween_property(self, "modulate:a", 0.0, 0.8)
			tween.tween_callback(func(): get_tree().change_scene_to_file("res://scenes/main.tscn"))
		else:
			# Fade out current text, then show next
			var tween = create_tween()
			tween.tween_property($StoryLabel, "modulate:a", 0.0, 0.3)
			tween.tween_callback(show_line)
