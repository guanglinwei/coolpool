class_name Ball;
extends RigidBody2D;

var velocity_epsilon: float = 0.20;
@onready var start_position: Vector2 = position;
var _reset_position: bool = false;
var _stop_ball: bool = false;

# To address bug where ball seems stopped, but velocity != 0
var last_velocities: Array[Vector2] = [];
const max_remembered_velocities = 16;
var curr_vel_ind = 0;

signal ball_entered_hole(index: int);

func _ready() -> void:
	for i in range(max_remembered_velocities):
		last_velocities.append(Vector2.INF);
	setup();
	
func setup() -> void:
	#position = Vector2(800, 600);
	pass;
	
func reset() -> void:
	#position = start_position;
	_reset_position = true;
	_stop_ball = false;
	self.set_deferred('freeze', false);
		
func on_enter_hole(index: int = -1) -> void:
	# TODO: score points
	self.visible = false;
	#self.set_freeze_enabled(true);
	self.set_deferred('freeze', true);
	_stop_ball = true;
	ball_entered_hole.emit(index);
	
func shoot(speed: float, torque: float = 0.0) -> void:
	_stop_ball = false;
	self.apply_impulse(Vector2(randf() - 0.5, randf() - 0.5).normalized() * 1000);
	self.apply_torque_impulse((randf() - 0.5) * 10000 );
	
func _physics_process(delta: float) -> void:	
	#var collision_info = move_and_collide(linear_velocity * delta);
	#rotate(angular_velocity * delta);
	#if collision_info:
		#if (collision_info.get_collider() as CollisionObject2D).is_in_group('ball'):
			##print('hole')
			#pass;
		##linear_velocity = linear_velocity.bounce(collision_info.get_normal());
	#if last_velocities.size() != max_remembered_velocities:
	
	var vel_not_changing = last_velocities.all(func (v): return v == self.linear_velocity);
	
	last_velocities[curr_vel_ind] = self.linear_velocity;
	curr_vel_ind = (curr_vel_ind + 1) % max_remembered_velocities;
	#print(vel_not_changing, last_velocities)
	
	if vel_not_changing or self.linear_velocity.length() < velocity_epsilon:
		self.linear_velocity = Vector2.ZERO;
		self.angular_velocity = 0;
		self.rotation = 0;
		#_stop_ball = true;

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if _reset_position:
		_reset_position = false;
		state.linear_velocity = Vector2.ZERO;
		state.angular_velocity = 0;
		state.transform.origin = start_position;
	elif _stop_ball:
		_stop_ball = false;
		state.linear_velocity = Vector2.ZERO;
		state.angular_velocity = 0;
