class_name GameController;
extends Node;

@export var ball_scene: PackedScene;
var balls: Array[Ball] = [];
@onready var cue_ball: CueBall = $'../CueBall';
@onready var table: Node2D = $'../Table';
@onready var game_ui: GameUIController = $'../GameUI';

enum BumperType {ADD, SUB, MULT, DIV};

var current_score: int = 0:
	set(value):
		print(value);
		current_score = value;
		game_ui.update_scores(target_score, curr_base_score, curr_mult, value, 
			round(acceptable_range[0] * target_score),
			round(acceptable_range[1] * target_score),
			value == 0);
			
@export var curr_mult: int = 1:
	set(value):
		curr_mult = value;
		current_score = round(value * curr_base_score);
@export var curr_base_score: int = 0:
	set(value):
		curr_base_score = value;
		current_score = round(curr_mult * value);
@export var target_score: int = 0;
var acceptable_range: Array[float] = [0.8, 1.2];
var level: int = 1;

var lives: int = 3;
var max_cue_balls: int = 5;
var curr_cue_balls: int = max_cue_balls;

func _ready() -> void:
	game_ui.reset();
	init_level(level);
	cue_ball.ball_hit_bumper.connect(on_ball_hit_bumper);
	
func init_level(level: int):
	var ball_rows = 3;
	if level > 4:
		ball_rows += 1;
	if level > 8:
		ball_rows += 1;
	
	curr_cue_balls = max_cue_balls;
	target_score = round(12 + 5 * ((level - 1) ** 1.5));
	curr_base_score = 0;
	curr_mult = 1;
	current_score = 0;
	setup_balls(ball_rows);

func end_level():
	# check if meet score range
	if current_score < target_score * acceptable_range[0] or \
		current_score > target_score * acceptable_range[1]:
			lives -= 1;
			init_level(level);
			
	else:
		level += 1;
		init_level(level);
	
func create_ball() -> Ball:
	var ball = ball_scene.instantiate() as Ball;
	self.add_child(ball);
	balls.append(ball);
	ball.ball_entered_hole.connect(on_ball_entered_hole);
	ball.ball_hit_bumper.connect(on_ball_hit_bumper);
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
				
			var pos = table.position + Vector2((row * gap) + (col * gap / 2), (col * gap)) - \
				Vector2.RIGHT * (rows - 1) * gap / 2 + \
				Vector2.UP * (rows / 2 * gap + 35);
			ball.position = pos;
			count += 1

func on_ball_entered_hole(index: int = -1):
	curr_base_score += 1;

func on_ball_hit_bumper(bumper_type: BumperType):
	print('asdjfkl')
	match bumper_type:
		BumperType.ADD:
			curr_base_score += 1;
		BumperType.SUB:
			curr_base_score = max(0, curr_base_score - 1);
		BumperType.MULT:
			curr_mult += 1;
		BumperType.DIV:
			curr_mult = max(0, curr_mult - 1);
		_:
			pass;
	
