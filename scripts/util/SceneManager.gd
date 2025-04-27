extends Node;

const scene_base_path: String = 'res://scenes/';

func switch_scene(scene_path: String):
	var scene = scene_base_path + scene_path + '.tscn';
	get_tree().change_scene_to_file(scene);
