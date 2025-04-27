extends Node2D

var ball_names = ["Ball", "balls2", "balls3", "balls4", "balls5"]
func lose_ball(current_balls):
	for i in range(ball_names.size()):
		var ball = get_node(ball_names[i])
		# Hide balls starting from the end
		if i >= current_balls:
			ball.visible = false
		else:
			ball.visible = true
