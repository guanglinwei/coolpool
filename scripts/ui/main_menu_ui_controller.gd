class_name MainMenuUIController;
extends Control;

@onready var selectors_node: Node2D = $'../../Selectors';
@onready var start_button: Button = $StartButton;
@onready var how_to_play_button: Button = $HowToPlayButton;

var currently_selected_ind: int = -1;
var selector_start_pos: Vector2;
const MENU_GAP = 34;

func _ready() -> void:
	selectors_node.visible = false;
	selector_start_pos = selectors_node.position;
	start_button.mouse_entered.connect(_on_mouse_entered.bind(0));
	how_to_play_button.mouse_entered.connect(_on_mouse_entered.bind(1));
	start_button.mouse_exited.connect(_on_mouse_exited.bind(0));
	how_to_play_button.mouse_exited.connect(_on_mouse_exited.bind(1));

func _on_mouse_entered(index: int = -1):
	selectors_node.visible = index >= 0;
	currently_selected_ind = index;
	selectors_node.position = selector_start_pos + Vector2.DOWN * index * MENU_GAP;

func _on_mouse_exited(index: int):
	if currently_selected_ind == index:
		currently_selected_ind = -1;
		selectors_node.visible = false;
