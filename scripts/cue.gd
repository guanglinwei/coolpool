class_name Cue;
extends AnimatedSprite2D;

#var viewport: Viewport = get_viewport();

var ball_to_shoot: Ball = null;
var shoot_speed: float = 250.0;
var shoot_torque_modifier: float = 125.0;
var dist_to_ball: float = 64.0;
var current_shoot_dir: Vector2 = Vector2.ZERO;
var can_shoot_ball: bool = true;
var ball_was_moving_last_frame = false;

func _ready() -> void:
	ball_to_shoot = $'../Ball';

func set_visibility(vis: bool) -> void:
	visible = vis;
	
func set_can_shoot_ball(can: bool) -> void:
	can_shoot_ball = can;
	set_visibility(can);
	
func shoot_ball(ball: Ball) -> void:
	ball.apply_impulse(current_shoot_dir * shoot_speed);
	ball.apply_torque_impulse((randf() - 0.5) * shoot_torque_modifier);

func _process(delta: float) -> void:
	if ball_to_shoot != null:
		# If ball is not moving, we can shoot it
		if not ball_was_moving_last_frame and \
			ball_to_shoot.linear_velocity == Vector2.ZERO and \
			not can_shoot_ball:
			print('can move now')
			set_can_shoot_ball(true);
		ball_was_moving_last_frame = ball_to_shoot.linear_velocity == Vector2.ZERO;
		
		var mouse_pos: Vector2 = get_viewport().get_mouse_position();
		current_shoot_dir = (ball_to_shoot.position - mouse_pos).normalized();
		if current_shoot_dir != Vector2.ZERO:
			self.position = ball_to_shoot.position - dist_to_ball * current_shoot_dir;
			self.rotation = (-current_shoot_dir).angle();
			
			if can_shoot_ball and Input.is_action_just_pressed("LeftClick"):
				shoot_ball(ball_to_shoot);
				set_can_shoot_ball(false);
