class_name GameController;
extends Node;

@export var ball_scene: PackedScene;
var balls: Array[Ball] = [];
@onready var cue_ball: CueBall = $'../CueBall';
@onready var table: Node2D = $'../Table';
@onready var game_ui: GameUIController = $'../GameUI';
@onready var balls_parent: Node = $'../RegularBalls';
var all_bumpers: Array[BaseBumper] = [];

enum BumperType {ADD, SUB, MULT, DIV};

var current_score: int = 0:
	set(value):
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
var acceptable_range: Array[float] = [0.66, 1.5];
var level: int = 1;

var lives: int = 3:
	set(value):
		lives = value;
		game_ui.lives_display.text = 'Lives: ' + str(value);
var max_cue_balls: int = 5;
var curr_cue_balls: int = max_cue_balls;

var ending_level: bool = false;

const TABLE_MIN_X = 212;
const TABLE_MAX_X = 288;
const TABLE_MIN_Y = 17;
const TABLE_MAX_Y = 163;
const INVALID_GEN_BOX_MIN_X = 236;
const INVALID_GEN_BOX_MIN_Y = 41;
const INVALID_GEN_BOX_MAX_X = 250;
const INVALID_GEN_BOX_MAX_Y = 69;

@export var easy_valid_bumpers: Array[PackedScene] = [];
@export var hard_valid_bumpers: Array[PackedScene] = [];

func _ready() -> void:
	var lion_pic = $'../Lionstuff/Lion2' as Sprite2D;
	lion_pic.hide()
	for child in $'../Bumpers'.get_children():
		var bumper = child as BaseBumper;
		all_bumpers.append(bumper);
		
	game_ui.reset();
	init_level(level);
	cue_ball.ball_hit_bumper.connect(on_ball_hit_bumper);
	
func init_level(level: int):
	var ball_rows = 3;
	acceptable_range = [0.66, 1.5];
	if level > 4:
		ball_rows += 1;
		acceptable_range = [0.7, 1.3];
	if level > 8:
		ball_rows += 1;
		acceptable_range = [0.8, 1.2];
	
	curr_cue_balls = max_cue_balls;
	target_score = round(12 + 5 * ((level - 1) ** 1.5));
	curr_base_score = 0;
	curr_mult = 1;
	current_score = 0;
	
	cue_ball.reset();
	
	update_ball_ui();
	
	setup_balls(ball_rows);
	for bumper in all_bumpers:
		bumper.reset();

func end_level():
	ending_level = true;
	# check if meet score range
	if current_score < target_score * acceptable_range[0] or \
		current_score > target_score * acceptable_range[1]:
			lives -= 1;
			if lives <= 0:
				game_over();
			else:
				init_level(level);
	else:
		lion_popup()
 
func lion_popup() -> void:
	var lion_stuff = $"../Lionstuff" 
	var lion_pic = lion_stuff.get_child(0)
	var lion_sound = lion_stuff.get_child(1)
	
	lion_sound.play()

	lion_pic.show()
	get_tree().create_timer(2).timeout.connect(func():
		lion_pic.hide();
		level += 1;
		print(level)
		init_level(level);
		ending_level = false;
	);



func create_ball() -> Ball:
	var ball = ball_scene.instantiate() as Ball;
	balls_parent.add_child(ball);
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
			
			ball.setup(pos);
			ball.position = pos;
			ball._reset_position = true;
			#ball.linear_velocity = Vector2.ZERO;
			#ball.angular_velocity = 0;
			#print('reset ball')
			count += 1

func on_ball_entered_hole(index: int = -1):
	curr_base_score += level;
	curr_cue_balls = min(5, curr_cue_balls + 1);
	update_ball_ui();

func on_ball_hit_bumper(bumper_type: BumperType):
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
	
func generate_level(level: int):
	randi_range(TABLE_MIN_X, TABLE_MAX_X);

# TODO: fix this functionality
func out_of_balls():
	if not ending_level:
		end_level();

func lose_a_ball():
	curr_cue_balls -= 1;
	update_ball_ui()
	play_ball_explosion()
	#if curr_cue_balls <= 0:
		#out_of_balls();

func update_ball_ui():
	game_ui.balls_display.update_ball_state(curr_cue_balls);

func play_ball_explosion():
	var ball_name_list = ["Ball", "balls2", "balls3", "balls4", "balls5"]
	#if balls die, they explode with the three animations
	
	
func game_over():
	#game over scene
	#get_tree().change_scene("Game_Over.tscn")
	SceneManager.switch_scene('Game_Over');
	#maybe play some music idk
	
func _physics_process(delta: float) -> void:
	if curr_cue_balls <= 0 and \
		cue_ball.linear_velocity == Vector2.ZERO and \
		balls.all(func(b): return b.linear_velocity == Vector2.ZERO):
			out_of_balls();
