extends RigidBody2D

func _ready() -> void:
	setup();
	
func setup() -> void:
	position = Vector2(800, 600);
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		shoot();
		
func shoot() -> void:
	self.apply_impulse(Vector2(randf() - 0.5, randf() - 0.5).normalized() * 1000);
	self.apply_torque_impulse((randf() - 0.5) * 10000 );
	
func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide(linear_velocity * delta);
	rotate(angular_velocity * delta);
	if collision_info:
		linear_velocity = linear_velocity.bounce(collision_info.get_normal());
