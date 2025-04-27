class_name BaseBumper;
extends CollisionObject2D;

var reset_position: bool = false;
var start_position: Vector2;

func _ready() -> void:
	start_position = position;

func reset() -> void:
	reset_position = true;
	self.position = start_position;
	self.rotation = 0;

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if reset_position:
		reset_position = false;
		state.linear_velocity = Vector2.ZERO;
		state.angular_velocity = 0;
		state.transform.origin = start_position;
