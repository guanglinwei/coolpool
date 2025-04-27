class_name Cue;
extends AnimatedSprite2D;

#var viewport: Viewport = get_viewport();

@onready var indicator: Line2D = $Indicator;

var ball_to_shoot: Ball = null;
var shoot_speed: float = 480.0;
var current_power: float = 0.0;
var shoot_torque_modifier: float = 50.0;
var dist_to_ball: float = 50.0;
const min_dist_to_ball: float = 18.0;
const max_dist_to_ball: float = 28.0;
var current_shoot_dir: Vector2 = Vector2.ZERO;
var can_shoot_ball: bool = true;
var ball_was_moving_last_frame = false;
var is_about_to_shoot: bool = false;
const MAX_CAN_SHOOT_SPEED: float = 3.0;
const POWER_METER_FILL_SPEED: float = 1.0;
const POWER_TO_BALL_DIST: float = 30.0;

func _ready() -> void:
	ball_to_shoot = $'../CueBall';

func set_visibility(vis: bool) -> void:
	visible = vis;
	
func set_can_shoot_ball(can: bool) -> void:
	can_shoot_ball = can;
	set_visibility(can);
	
func shoot_ball(ball: Ball) -> void:
	#ball.apply_impulse(current_power * current_shoot_dir * shoot_speed * dist_to_ball / max_dist_to_ball);
	
	ball.apply_impulse(current_power * current_shoot_dir * shoot_speed);
	ball.apply_torque_impulse(current_power * (randf() - 0.5) * shoot_torque_modifier);
	current_power = 0;
	#just added this
	$"/root/Game_Controller".lose_a_ball()
	

func _process(delta: float) -> void:
	if ball_to_shoot != null:
		# If ball is not moving, we can shoot it
		#if not ball_was_moving_last_frame and \
			#ball_to_shoot.linear_velocity == Vector2.ZERO and \
			#not can_shoot_ball:
			#set_can_shoot_ball(true);
		if not can_shoot_ball and ball_to_shoot.linear_velocity.length() <= MAX_CAN_SHOOT_SPEED:
			set_can_shoot_ball(true);
		ball_was_moving_last_frame = ball_to_shoot.linear_velocity == Vector2.ZERO;
		
		var mouse_pos: Vector2 = get_viewport().get_mouse_position();
		var mouse_displacement: Vector2 = ball_to_shoot.position - mouse_pos;
		current_shoot_dir = mouse_displacement.normalized();
		dist_to_ball = clampf(mouse_displacement.length(), min_dist_to_ball, max_dist_to_ball);
		if current_shoot_dir != Vector2.ZERO:
			self.position = ball_to_shoot.position \
			- (dist_to_ball + 44.0 + current_power * POWER_TO_BALL_DIST) * current_shoot_dir;
			self.rotation = (-current_shoot_dir).angle() + 3*PI/2;
			
			# Directional indicator
			indicator.position.y = -dist_to_ball - 44.0 - current_power * POWER_TO_BALL_DIST;
			indicator.points[1].x = 66.0 * (1.0 + current_power / 2.0);
			(indicator.texture as GradientTexture1D).width = 8 + 4 * current_power;
			
			if can_shoot_ball:
				if Input.is_action_just_pressed("LeftClick"):
					current_power = 0;
				if Input.is_action_pressed("LeftClick"):
					current_power = min(1.0, current_power + POWER_METER_FILL_SPEED * delta);
				if Input.is_action_just_released("LeftClick"):
					shoot_ball(ball_to_shoot);
					set_can_shoot_ball(false);
