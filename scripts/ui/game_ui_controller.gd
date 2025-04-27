class_name GameUIController;
extends Node2D;

@onready var lion_sprite: AnimatedSprite2D = $Control/NinePatchRect/Header/Lion;
@onready var target_score_display: Label = $Control/NinePatchRect/Header/TargetScore;
@onready var base_score_display: Label = $Control/NinePatchRect/ScoreBox/NinePatchRect/CurrentBaseScore;
@onready var mult_display: Label = $Control/NinePatchRect/ScoreBox/NinePatchRect2/CurrentMult;
@onready var total_score_display: Label = $Control/NinePatchRect/ScoreBox/NinePatchRect3/CurrentTotalScore;
@onready var score_tip: Label = $Control/NinePatchRect/ScoreBox/ScoreTip;
@onready var score_tip_arrow: AnimatedSprite2D = $Control/NinePatchRect/ScoreBox/ScoreTip/Arrow;
@onready var balls_display: BallsDisplayController = $Balls;
@onready var lives_display: Label = $Control/NinePatchRect/ScoreBox/LifeCount;

var _target_score: int;
var _base_score: int;
var _mult: int;
var _total_score: int;

func reset() -> void:
	update_scores(0, 0, 0, 0, 0, 0, true);

func update_scores(target_score: int, base_score: int, mult: int, total_score: int,
				   ok_range_min: int, ok_range_max: int, force_update: bool = false):
	if target_score_display == null or \
		base_score_display == null or \
		mult_display == null or \
		total_score_display == null:
			return;
	
	if force_update or target_score != _target_score:
		target_score_display.text = str(target_score);
	if force_update or base_score != _base_score:
		base_score_display.text = str(base_score);
	if force_update or mult != _mult:
		mult_display.text = str(mult);
		
	if force_update or total_score != _total_score:
		total_score_display.text = str(total_score);
		# Super low
		if total_score < ok_range_min:
			lion_sprite.frame = 4; 
			score_tip.text = 'TOO LOW';
			score_tip_arrow.frame = 3;
		# Super high
		elif total_score > ok_range_max:
			lion_sprite.frame = 4; 
			score_tip.text = 'TOO HIGH';
			score_tip_arrow.frame = 1;
		# OK low
		elif total_score < target_score:
			lion_sprite.frame = 1; 
			score_tip.text = 'OK';
			score_tip_arrow.frame = 2;
		# OK high
		elif total_score > target_score:
			lion_sprite.frame = 1; 
			score_tip.text = 'OK';
			score_tip_arrow.frame = 0;
		# PERFECT
		else:
			lion_sprite.frame = 3; 
			score_tip.text = 'WOW';
			score_tip_arrow.frame = 4;
			
	_target_score = target_score;
	_base_score = base_score;
	_mult = mult;
	_total_score = total_score;
	
