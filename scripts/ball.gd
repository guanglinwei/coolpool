class_name Ball;
extends RigidBody2D;

var velocity_epsilon: float = 0.10;

func _ready() -> void:
	setup();
	
func setup() -> void:
	#position = Vector2(800, 600);
	pass;
	
#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("ui_accept"):
		#shoot();
	
func shoot(speed: float, torque: float = 0.0) -> void:
	self.apply_impulse(Vector2(randf() - 0.5, randf() - 0.5).normalized() * 1000);
	self.apply_torque_impulse((randf() - 0.5) * 10000 );
	
func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide(linear_velocity * delta);
	rotate(angular_velocity * delta);
	if collision_info:
		#if collision_info.get_collider()
		linear_velocity = linear_velocity.bounce(collision_info.get_normal());
		
	if self.linear_velocity.length() < velocity_epsilon:
		self.linear_velocity = Vector2.ZERO;
