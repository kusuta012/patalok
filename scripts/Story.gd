extends Control

var story_lines = [
	"In the ancient realm of Paatalok, beneath the earth...",
	"The Demon King Narakasur has risen to challenge the Prince.",
	"Only through combat can balance be restored.",
	"3 rounds. Last one standing wins.",
	"Let the battle begin!"
]

var current_line = 0

func _ready():
	$StoryLabel.text = story_lines[current_line]
	$ContinueLabel.text = "Press ENTER to continue..."

func _input(event):
	if event.is_action_pressed("ui_accept"):
		current_line += 1
		if current_line >= story_lines.size():
			get_tree().change_scene_to_file("res://scenes/main.tscn")
		else:
			$StoryLabel.text = story_lines[current_line]
