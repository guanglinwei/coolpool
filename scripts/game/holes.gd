extends Area2D;

func _on_body_entered(body: Node2D) -> void:
	if not (body is Ball):
		return;
		
	var ball = body as Ball;
	print(ball.name)
	
	# TODO: play anim
	ball.on_enter_hole();
