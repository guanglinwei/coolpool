class_name CueBall;
extends Ball;

func on_enter_hole(index: int = -1) -> void:
	# TODO: play anim
	self.visible = false;
	reset();
	self.rotation = 0.0;
	self.visible = true;
	
func _physics_process(delta: float) -> void:
	#print(self.linear_velocity)
	super(delta);
