extends Node2D

var player1 = null
var player2 = null

func _ready():
	await get_tree().process_frame
	
	# Find Player 1
	var players = get_tree().get_nodes_in_group("player1")
	print("Number of Player1 nodes found: ", players.size())
	for i in range(players.size()):
		print("Player1 [", i, "]: ", players[i].name, " at position: ", players[i].global_position)
	
	if players.size() > 0:
		player1 = players[0]
		print("Found Player 1: ", player1.name)
	else:
		print("ERROR: Player 1 not found!")
	
	# Find Player 2
	var demons = get_tree().get_nodes_in_group("player2")
	print("Number of Player2 nodes found: ", demons.size())
	for i in range(demons.size()):
		print("Player2 [", i, "]: ", demons[i].name, " at position: ", demons[i].global_position)
	
	if demons.size() > 0:
		player2 = demons[0]
		print("Found Player 2: ", player2.name)
	else:
		print("ERROR: Player 2 not found!")
	
	# Print initial distance (using collision shape centers for accuracy)
	if player1 and player2:
		var p1_center = player1.get_node("CollisionShape2D").global_position
		var p2_center = player2.get_node("CollisionShape2D").global_position
		var initial_dist = p1_center.distance_to(p2_center)
		print("Initial distance between players: ", initial_dist)

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
	


func _process(_delta):  # Changed "delta" to "_delta" to fix the warning
	queue_redraw()
	
	# Debug: Print distance every second (using collision shape centers)
	if Engine.get_frames_drawn() % 60 == 0:
		if player1 and player2:
			var p1_center = player1.get_node("CollisionShape2D").global_position
			var p2_center = player2.get_node("CollisionShape2D").global_position
			var dist = p1_center.distance_to(p2_center)
			print("Distance: ", int(dist), " | P1 center: ", p1_center, " | P2 center: ", p2_center)
