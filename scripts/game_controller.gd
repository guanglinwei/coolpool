extends Node;

@export var ball_scene: PackedScene;
var balls: Array[Ball] = [];
@onready var table: Node2D = $'../Table';

var current_score: int = 0;
var curr_mult: float = 1.0;
var curr_base_score: int = 3;
var target_score: int = 0;
var acceptable_range: Array[float] = [0.8, 1.2];
var level: int = 1;

var lives: int = 3;
var max_cue_balls: int = 5;
var curr_cue_balls: int = max_cue_balls;

func _ready() -> void:
	init_level(level);
	
func init_level(level: int):
	var ball_rows = 3;
	if level > 4:
		ball_rows += 1;
	if level > 8:
		ball_rows += 1;
	
	curr_cue_balls = max_cue_balls;
	setup_balls(ball_rows);
	
func end_level():
	# check if meet score range
	# lose life if not
	# move on if yes
	pass
	
func create_ball() -> Ball:
	var ball = ball_scene.instantiate() as Ball;
	self.add_child(ball);
	balls.append(ball);
	return ball;
		
func setup_balls(rows: int = 5):
	var count = 0;
	var gap = 7;
	for col in range(rows):
		for row in range(rows - col):
			var ball: Ball = null;
			if count >= balls.size():
				ball = create_ball();
			else:
				ball = balls[count];
			#var b = ball_scene.instantiate()
			var pos = table.position + Vector2((row * gap) + (col * gap / 2), (col * gap)) - \
				Vector2.RIGHT * (rows - 1) * gap / 2 + \
				Vector2.UP * (rows / 2 * gap + 35);
			ball.position = pos;
			count += 1
