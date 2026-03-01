extends Node2D

var player1 = null
var player2 = null

func _ready():
	await get_tree().process_frame
	var players = get_tree().get_nodes_in_group("player1")
	if players.size() > 0:
		player1 = players[0]
	
	var demons = get_tree().get_nodes_in_group("player2")
	if demons.size() > 0:
		player2 = demons[0]

func _draw():
	# Get camera position to draw UI in screen space
	var cam_pos = Vector2.ZERO
	if get_viewport().get_camera_2d():
		cam_pos = get_viewport().get_camera_2d().get_screen_center_position() - get_viewport_rect().size / 2
	
	# Player 1 HP Bar (Top Left)
	var p1_hp_percent = 0.0
	if player1:
		p1_hp_percent = float(player1.current_health) / float(player1.max_health)
	
	draw_rect(Rect2(cam_pos + Vector2(20, 20), Vector2(200, 30)), Color.BLACK)
	draw_rect(Rect2(cam_pos + Vector2(20, 20), Vector2(200 * p1_hp_percent, 30)), Color.GREEN)
	draw_string(ThemeDB.fallback_font, cam_pos + Vector2(30, 42), "P1: " + str(player1.current_health if player1 else 0) + "/100", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color.WHITE)
	
	# Player 2 HP Bar (Top Right)
	var p2_hp_percent = 0.0
	if player2:
		p2_hp_percent = float(player2.current_health) / float(player2.max_health)
	
	var screen_width = get_viewport_rect().size.x
	draw_rect(Rect2(cam_pos + Vector2(screen_width - 220, 20), Vector2(200, 30)), Color.BLACK)
	draw_rect(Rect2(cam_pos + Vector2(screen_width - 220, 20), Vector2(200 * p2_hp_percent, 30)), Color.RED)
	draw_string(ThemeDB.fallback_font, cam_pos + Vector2(screen_width - 210, 42), "P2: " + str(player2.current_health if player2 else 0) + "/100", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color.WHITE)

func _process(delta):
	queue_redraw()  # Redraw every frame
